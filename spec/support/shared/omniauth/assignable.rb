shared_examples_for 'assignable' do
  it 'assigns the user' do
    post method.to_sym
    expect(assigns(:user)).to eq user
  end
end
