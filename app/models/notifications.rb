class Notifications < ActionMailer::Base
  def forgot_password(to, login, pass, sent_at = Time.now)
    @subject    = "WaterLogged - Your password is ..."
    @body['login']=login
    @body['pass']=pass
    @recipients = to
    @from       = 'andy@mywaterlogged.com'
    @sent_on    = sent_at
    @headers    = {}
  end
end