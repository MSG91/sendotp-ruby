require 'send_otp/version'
require 'uri'
require 'net/http'
module SendOtp

  class Otp


    #variable auth_key; //MSG91 auth key
    #variable message_template = "Your otp is {{otp}}. Please do not share it with anybody" //message template to send, {{otp}} is required to inject generated otp

    # Creates a new SendOtp instance
    # @param {string} auth_jey Authentication key
    # @param {string, optional} message_template

    def initialize(auth_key, message_template=nil)
      @auth_key = auth_key
      if message_template
        @message_template = message_template
      else
        @message_template = 'Your otp is {{otp}}. Please do not share it with anybody'
      end
    end

    # Send Otp to given mobile number
    # @param {string} contact_number receiver's mobile number along with country code
    # @param {string} sender_id
    # @param {string, optional} otp
    # @param {string, optional} n number of digits of Otp

    def send_otp(contact_number, sender_id, otp = '', n = 4)
      otp = generate_otp(n) if otp.to_s.empty?
      @message_template.gsub! '{{otp}}', otp.to_s
      args = {
          authkey: @auth_key,
          mobile: contact_number,
          sender: sender_id,
          message: @message_template,
          otp: otp
      }

      do_request('sendotp.php', args)
    end


    # Retry Otp to given mobile number
    # @param {string} contact_number receiver's mobile number along with country code
    # @param {boolean} retry_voice, false to retry otp via text call, default true

    def retry(contact_number, retry_voice)
      # if retry voice is false, set `retry_type` as `text` else set it to `voice` call msg91 API to retry otp
      # return msg91 API response
      retry_type =  'voice'
      retry_type = 'text' unless retry_voice
      args = {
          authkey: @auth_key,
          mobile: contact_number,
          retrytype: retry_type
      }
      do_request('retryotp.php', args)
    end


    # Verify Otp to given mobile number
    # @param {string} contact_number receiver's mobile number along with country code
    # @param {string} otp otp to verify
    # Return true if OTP verified successfully
    # @returns {boolean} true if otp verified successfully else false

    def verify(contact_number, otp)
      args = {
          authkey: @auth_key,
          mobile: contact_number,
          otp: otp
      }

      response = do_request('verifyRequestOTP.php', args)
      body = eval(response.body)

      if body[:type] == 'success'
        true
      else
        false
      end
    rescue
      false
    end


    private


    # Returns the base URL for MSG91 api call
    # @returns {string} Base URL for MSG91 api call

    def get_base_url
      'https://control.msg91.com/api/'
    end

    def generate_random_number(upper_limit, lower_limit)
      Random.rand(upper_limit-lower_limit)+lower_limit
    end

    # returns a n digit random number
    def generate_otp(n = 4)
      smallest_num_of_n_plus1_digits = 10 ** n
      smallest_num_of_n_digits = 10 ** (n-1)
      rand_number = generate_random_number(smallest_num_of_n_plus1_digits, smallest_num_of_n_digits)
      while rand_number > smallest_num_of_n_plus1_digits || rand_number < smallest_num_of_n_digits
        rand_number = generate_random_number(smallest_num_of_n_plus1_digits, smallest_num_of_n_digits)
      end

      rand_number
    end


    # Common private method to make HTTP request
    # call this in above three methods (send, retry, verify)
    # @param {string} path, MSG91 API's endpoint
    # @param {json} params, arguments to send in API

    def do_request(url, args)
      uri = URI.parse(get_base_url + url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' => 'application/json'})
      request.set_form_data(args)
      http.request(request)
    end
  end

end
