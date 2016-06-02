require "spec_helper"

describe CleanSettings::HasSettings do
  before :each do
    @number = 100
    @string = "string"
    @h = { a: 1, b: 2 }
    @array = [1, 2]
    @boolean = true

    @user = User.create
  end

  describe "with user" do
    it "set settings for specific user" do
      @user.settings.number = @number
      @user.settings.string = @string
      @user.settings.h = @h
      @user.settings.array = @array
      @user.settings.boolean = @boolean

      expect(@user.settings.fetch).to be_kind_of(Hash)
      expect(@user.settings.fetch.keys.size).to eq 5
      expect(@user.settings.number).to eq @number
      expect(@user.settings.array).to eq @array
      expect(@user.settings.string).to eq @string
      expect(@user.settings.h).to eq @h
      expect(@user.settings.boolean).to eq @boolean
    end

    it "settings available through hash or object notations" do
      @user.settings.array = @array
      @user.settings[:h] = @h

      expect(@user.settings[:array]).to eq @array
      expect(@user.settings.h).to eq @h
    end

    describe "scope :with_setting" do
      it "get users from target setting" do
        user_2 = User.create

        @user.settings.boolean = @boolean

        expect(User.with_setting(:boolean).count).to eq 1
        expect(User.with_setting(:boolean).first).to eq @user
      end
    end
  end
end
