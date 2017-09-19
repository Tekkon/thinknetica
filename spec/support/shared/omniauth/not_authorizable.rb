shared_examples_for 'not-authorizable' do
  it 'not creates authorization' do
    expect { post method.to_sym }.to_not change(Authorization, :count)
  end
end
