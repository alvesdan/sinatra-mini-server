class MiniServerApp < Sinatra::Base

  USERS_LIMIT = 400

  def users_fake_list(total = 10)
    users = []
    total.times { users << create_fake_user }
    users
  end

  def create_fake_user
    {
      id: Faker::Code.ean,
      name: Faker::Name.name,
      email: Faker::Internet.email
    }
  end

  def pages_hash
    {
      pages: {
        next: "http://localhost:9292/users?per_page=#{per_page}&page=#{current_page + 1}",
        page: current_page,
        per_page: per_page,
        total_pages: total_pages
      }
    }
  end

  def current_page
    params[:page].to_i
  end

  def per_page
    params[:per_page].to_i
  end

  def total_pages
    (USERS_LIMIT / per_page).ceil
  end

  def current_users_count
    current_page * per_page
  end

  get '/*' do
    sleep(rand(0..1)) # Simulating latency
    content_type :json
    base_hash = {
      total_count: USERS_LIMIT,
      users: users_fake_list(per_page)
    }
    base_hash.merge!(pages_hash) if current_users_count < USERS_LIMIT
    base_hash.to_json
  end
end
