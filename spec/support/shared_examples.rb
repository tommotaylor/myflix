shared_examples "requires sign in" do
  it "redirects to the front page" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "saves the token" do
  it "creates and sets the token on the object" do
    object
    action
    expect(object.reload.token).to be_present
  end
end
