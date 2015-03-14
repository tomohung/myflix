shared_examples 'require_sign_in' do
  it 'redirects to sign in page' do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples 'queue_done' do
  it 'redirects to the my queue page' do
    action
    expect(response).to redirect_to my_queue_path
  end
end