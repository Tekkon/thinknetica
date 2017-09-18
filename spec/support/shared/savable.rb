shared_examples_for 'savable' do
  it 'saves the new question in the database' do
    expect { request }.to change(model, :count).by(1)
  end

  it 'sets a current_user to the new question' do
    sign_in_the_user(user)
    request
    expect(assigns(model.to_s.downcase.to_sym).user_id).to eq user.id
  end
end
