shared_examples_for 'user-creatable' do
  it 'creates a user' do
    expect { post method.to_sym }.to change(User, :count).by(1)
  end
end
