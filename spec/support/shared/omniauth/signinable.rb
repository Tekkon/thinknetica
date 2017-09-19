shared_examples_for 'signinable' do
  it 'signs in with user' do
    post method.to_sym
    expect(subject.current_user).to eq user
  end

  it 'redirects to root path' do
    post method.to_sym
    expect(response).to redirect_to root_path
  end
end
