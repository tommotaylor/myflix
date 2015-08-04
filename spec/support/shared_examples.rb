shared_examples "requires sign in" do
  it "redirects to the front page" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end