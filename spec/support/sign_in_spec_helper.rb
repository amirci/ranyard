module SignInSpecHelper

  def sign_in
    session[:user_id] = 1
    User.stub(:find).with(1).and_return(stub_model(User))
  end

  def sign_up(email, pwd)
    user = stub_model(User, id: 1, email: email)

    User.stub(:find_by_email).with(anything).and_return(nil)
    User.stub(:find_by_email).with(email).and_return(user)

    user.stub(:authenticate).with(anything).and_return(false)
    user.stub(:authenticate).with(pwd).and_return(true)

    user
  end
end
