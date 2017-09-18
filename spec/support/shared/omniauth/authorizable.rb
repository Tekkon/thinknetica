shared_examples_for 'authorizable' do
  it 'creates authorization for user' do
    post method.to_sym
    expect(user.authorizations.count).to eq 1
    expect(user.authorizations.first.provider).to eq method
    expect(user.authorizations.first.uid).to eq '12345'
  end
end
