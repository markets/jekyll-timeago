RSpec.describe 'Global shortcuts' do
  describe 'T method' do
    it 'acts as a shortcut for MiniI18n.t' do
      expect(T(:hello)).to eq 'hello'
      expect(T(:hello, locale: :fr)).to eq 'bonjour'
    end
    
    it 'supports all the same options as MiniI18n.t' do
      expect(T('hello_interpolation', name: 'world')).to eq 'hello world'
      expect(T('notifications', count: 1)).to eq '1 unread notification'
      expect(T('non_existent_key', default: 'default')).to eq 'default'
    end
  end

  describe 'L method' do
    it 'acts as a shortcut for MiniI18n.l' do
      expect(L(1000.25)).to eq '1,000.25'
    end
    
    it 'supports all the same options as MiniI18n.l' do
      expect(L(1000, as: :currency)).to eq '1,000 $'
    end
  end
end