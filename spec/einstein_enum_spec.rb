require "einstein-enum"


ROOT = "https://api.api.com/api/v1"


# defining an enum
class Api < Enum
  value :Status
  value :User, Fixnum
  value :User, String
  value :Posts, raw_value: :posts

  def root
    ROOT
  end

  def url
    case self
    when Status
      root + "/status"
    when User(Fixnum)
      id = self[0]
      root + "/users/by_id/#{id}"
    when User(String)
      username = self[0]
      root + "/users/by_name/#{username}"
    when Posts
      root + "/posts"
    else
      nil
    end
  end

end


# extending an Enum
class AnotherApi < Api
  value :PostDetail, Fixnum

  def url
    case self
    when PostDetail(Fixnum)
      root + "/posts/#{self[0]}"
    else
      super
    end
  end

end


# edge cases
class EdgeCases < Enum
  value :lower_case
end


RSpec.describe EinsteinEnum do

  before do
    @status = Api.Status
    @user_type = Api.User(Fixnum)
    @user_id = Api.User(2)
    @user_name = Api.User('colinta')
    @posts = Api.Posts
    @post_detail = AnotherApi.PostDetail(2)
  end

  describe "matches" do
    it "should match Api.Status" do
      expect(case @status
      when Api.Status
        true
      when Api.User(Fixnum)
        false
      else
        false
      end).to(eq(true))
    end

    it "should match Api.Status" do
      expect(case @status
      when Api.Status
        true
      when Api.User(Fixnum)
        false
      else
        false
      end).to eq(true)
    end

    it "should match Api.User(Fixnum)" do
      expect(case @user_id
      when Api.Status
        false
      when Api.User(String)
        false
      when Api.User(Fixnum)
        true
      else
        false
      end).to eq(true)
    end

    it "should match Api.User(String)" do
      expect(case @user_name
      when Api.Status
        false
      when Api.User(Fixnum)
        false
      when Api.User(String)
        true
      else
        false
      end).to eq(true)
    end

    it "should match Api.User(2)" do
      expected_id = 2
      expect(case @user_id
      when Api.Status
        false
      when Api.User(expected_id - 1)
        false
      when Api.User(expected_id)
        true
      else
        false
      end).to eq(true)
    end
  end

  describe "raw values" do
    it "should be unique" do
      expect(@status.raw_value).not_to eq(@user_id.raw_value)
      expect(@status.raw_value).not_to eq(@user_name.raw_value)
      expect(@status.raw_value).not_to eq(@posts.raw_value)

      expect(@user_id.raw_value).not_to eq(@user_name.raw_value)
      expect(@user_id.raw_value).not_to eq(@posts.raw_value)

      expect(@user_name.raw_value).not_to eq(@posts.raw_value)
    end

    it "should be customizable" do
      expect(@posts.raw_value).to eq(:posts)
    end
  end

  describe "methods" do
    it "should define constants" do
      expect(Api.Status).to be_a_kind_of(Enum)
    end

    it "should define methods" do
      expect(Api.Status()).to be_a_kind_of(Enum)
    end

    it "should define instance methods" do
      expect(Api.Status.Status()).to be_a_kind_of(Enum)
    end

    it "should create the Status url string" do
      expect(Api.Status.url).to eq(ROOT + "/status")
      expect(@status.url).to eq(ROOT + "/status")
    end

    it "should create the User(Fixnum) url string" do
      expect(@user_id.url).to eq(ROOT + "/users/by_id/2")
    end

    it "should create the User(String) url string" do
      expect(@user_name.url).to eq(ROOT + "/users/by_name/colinta")
    end

    it "should create the Post url string" do
      expect(@posts.url).to eq(ROOT + "/posts")
    end

    it "should create the PostDetail(Fixnum) url string" do
      expect(@post_detail.url).to eq(ROOT + "/posts/2")
    end
  end

  describe "edge cases" do
    it "should have `EdgeCases.lower_case`" do
      expect(EdgeCases.lower_case).to be_a_kind_of(Enum)
    end
  end

end
