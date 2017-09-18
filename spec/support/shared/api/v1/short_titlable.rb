shared_examples_for 'short-titlable' do
  it 'question object contains short_title' do
    expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path(short_title_path)
  end
end
