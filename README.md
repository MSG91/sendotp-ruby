# SendOtp

This SDK enables sendOTP and allows you to send OTP

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'send_otp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install send_otp  
        
### Requests  
```
sendotp = SendOtp::Otp.new('AuthKey')  
sendotp.send_otp(contact_number, sender_id, otp); //otp is optional if not sent it'll be generated automatically  
sendotp.retry(contact_number, retry_voice);  
sendotp.verify(contact_number, otp);  
```
### Usage

To send OTP, without optional parameters 
```
sendotp.send_otp("919999999999", "PRIIND")
```  

To send OTP, with optional parameters  
```
sendotp.send_otp("919999999999", "PRIIND", "4635")
```

To retry OTP
```
sendotp.retry("919999999999", false)
```
**Note:** Set retry_voice false if you want to retry otp via text, default value is true

To verify OTP

```
sendotp.verify("919999999999", "4635");
```
**Options**:

By default SendOtp uses default message template, but custom message template can also set in constructor like
```
sendotp = SendOtp::Otp.new('AuthKey', 'Otp for your order is {{otp}}, please do not share it with anybody')  
```  
{{otp}} expression is used to inject generated otp in message.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MSG91/sendotp-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

