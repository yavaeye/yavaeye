# encoding: UTF-8

require "openid"
require 'openid/extensions/sreg'
require 'openid/extensions/ax'
require 'openid/store/interface'

module OpenID
  # also request email
  class YavaConsumer < Consumer
    def initialize session
      super(session, Store::DbStore.new)
    end

    def redirect_url identifier, host, path
      req = self.begin identifier

      # simple registration extension
      sreg = SReg::Request.new
      sreg.request_fields ['email'], true
      req.add_extension sreg

      # google / yahoo uses attribute exchange extension
      ax = AX::FetchRequest.new
      ax.add(AX::AttrInfo.new "http://axschema.org/contact/email", 'email', true)
      req.add_extension ax

      # fuck: openid could only redirect to http urls
      req.redirect_url "http://#{host}", "http://#{host}#{path}"
    rescue DiscoveryFailure
    end

    # return [fail_msg, openid, email]
    def complete params, url
      r = super params, url
      case r.status
      when SUCCESS
        email =
          if ax_resp = AX::FetchResponse.from_success_response(r)
            ax_resp.data["http://axschema.org/contact/email"]
          elsif sreg_resp = SReg::Response.from_success_response(r)
            sreg_resp.data["email"]
          end
        [nil, r.display_identifier, *email]
      when FAILURE
        "无法验证"
      when SETUP_NEEDED
        "请求失败"
      when CANCEL
        "登录取消"
      else
        "未知错误"
      end
    end
  end

  # mongodb store, https://gist.github.com/601236
  module Store
    class Association
      include Mongoid::Document
      field :secret, :type => Binary

      def from_record
        OpenID::Association.new(handle, secret.to_s, issued, lifetime, assoc_type)
      end
    end

    class Nonce
      include Mongoid::Document
    end

    class DbStore < OpenID::Store::Interface
      def self.cleanup_nonces
        now = Time.now.to_i
        Nonce.delete_all(["timestamp > ? OR timestamp < ?", now + OpenID::Nonce.skew, now - OpenID::Nonce.skew])
      end

      def self.cleanup_associations
        now = Time.now.to_i
        Association.delete_all(['issued + lifetime > ?',now])
      end

      def store_association(server_url, assoc)
        remove_association(server_url, assoc.handle)

        # BSON::Binary is used because secrets raise an exception
        # due to character encoding
        Association.create(:server_url => server_url,
                           :handle     => assoc.handle,
                           :secret     => BSON::Binary.new(assoc.secret),
                           :issued     => assoc.issued,
                           :lifetime   => assoc.lifetime,
                           :assoc_type => assoc.assoc_type)
      end

      def get_association(server_url, handle = nil)
        assocs = if handle.blank?
          Association.find :all, :conditions => { :server_url => server_url }
        else
          Association.find :all, :conditions => { :server_url => server_url, :handle => handle }
        end

        assocs.reverse.each do |assoc|
          a = assoc.from_record
          if a.expires_in == 0
            assoc.destroy
          else
            return a
          end
        end if assocs.any?

        return nil
      end

      def remove_association(server_url, handle)
        Association.find(:all, :conditions => { :server_url => server_url, :handle => handle }).each do |assoc|
          assoc.destroy!
        end
      end

      def use_nonce(server_url, timestamp, salt)
        return false if Nonce.find(:first, :conditions => { :server_url => server_url, :timestamp => timestamp, :salt => salt})
        return false if (timestamp - Time.now.to_i).abs > OpenID::Nonce.skew
        Nonce.create(:server_url => server_url, :timestamp => timestamp, :salt => salt)
        return true
      end
    end
  end
end
