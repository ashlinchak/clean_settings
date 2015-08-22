require "spec_helper"

describe CleanSettings::Setting do
  before :all do
    @number = 100
    @string = "string"
    @h = { a: 1, b: 2 }
    @array = [1, 2]
    @boolean = true
  end

  before :each do
    CleanSetting.clear_defaults
  end

  describe "Global settings" do
    it "set and get global settings" do
      CleanSetting.number = @number
      CleanSetting.string = @string
      CleanSetting.h = @h
      CleanSetting.array = @array
      CleanSetting.boolean = @boolean

      expect(CleanSetting.number).to eq @number
      expect(CleanSetting.string).to eq @string
      expect(CleanSetting.h).to eq @h
      expect(CleanSetting.array).to eq @array
    end

    it "save settings to DB" do
      expect(CleanSetting.count).to eq 0

      CleanSetting.number = @number

      expect(CleanSetting.count).to eq 1
    end

    describe ".[]" do
      it "save settings with array and object notations" do
        CleanSetting[:array] = @array

        expect(CleanSetting[:array]).to eq @array
        expect(CleanSetting.array).to eq @array
      end
    end

    describe ".destroy" do
      it "destroy setting" do
        CleanSetting.h = @h
        CleanSetting.destroy(:h)

        expect(CleanSetting.h).to be_nil
      end
    end
  end

  describe "Defaults settings" do
    it "use defaults as regular global settings" do
      CleanSetting.defaults[:number] = @number

      expect(CleanSetting.defaults).to be_kind_of(OpenStruct)
      expect(CleanSetting.defaults[:number]).to eq @number
      expect(CleanSetting.defaults["number"]).to eq @number
      expect(CleanSetting.defaults.number).to eq @number
      expect(CleanSetting.number).to eq @number
    end

    it "get value from reqular setting when with same name was defined regular and default settings " do
      string = "another string"
      CleanSetting.string = @string
      CleanSetting.defaults[:string] = string

      expect(CleanSetting.string).to eq @string
      expect(CleanSetting.defaults.string).to eq string
    end

    describe ".fetch_defaults" do
      it "return defaults settings in a hash" do
        CleanSetting.defaults.boolean = @boolean
        CleanSetting.defaults.number = @number

        expect(CleanSetting.fetch_defaults).to be_kind_of(Hash)
        expect(CleanSetting.all_defaults).to be_kind_of(Hash)
        expect(CleanSetting.all_defaults).to eq ({ :boolean => @boolean, :number => @number }.with_indifferent_access)
      end
    end

    describe ".clear_defaults" do
      it "remove all default settings" do
        CleanSetting.defaults.boolean = @boolean
        CleanSetting.defaults.number = @number
        CleanSetting.clear_defaults

        expect(CleanSetting.fetch_defaults.blank?).to be true
      end
    end
  end

  describe ".fetch" do
    it "get all settings" do
      CleanSetting.h = @h
      CleanSetting.number = @number
      CleanSetting.defaults[:string] = @string

      expect(CleanSetting.fetch).to be_kind_of(Hash)
      expect(CleanSetting.fetch.size).to eq 3
      expect(CleanSetting.all_settings.size).to eq 3
    end
  end
end