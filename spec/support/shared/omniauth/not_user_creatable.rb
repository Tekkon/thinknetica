shared_examples_for 'not-user-creatable' do
  it 'not creates a user' do
    expect { post method.to_sym }.to_not change(User, :count)
  end
end
