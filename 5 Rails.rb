- app: Folder chứa phần lớn source code mà ta sẽ viết cho chương trình follow theo mô hình MVC
- assets: Chứa các thành phần hỗ trợ cho View như images chứa hình ảnh, javascript chứa các file javascript, stylesheets chứa các file CSS
- controllers: Gồm các file controller định nghĩa cho chương trình
- helpers: Chứa các phương thức helper
- mailers: Các phương thức cho chức năng email của chương trình
- models: Những file định nghĩa model của từng controllers
- views: Chứa các view, layout hiển thị cho người dùng
- config: Chứa tất cả các file config của ứng dụng như kết nối database...
  + application.rb : Chứa những config chính cho chương trình như timzone, language,...
  + database.yml: Các config database cho các môi trường khác nhau như development, production, tét...
  + routes.rb: Tất các đường dẫn trong ứng dụng được định nghĩa ở đây
  + locales: Chứa các file language
  + initializers: Chứa các file cần thiết khi khởi tạo Rails
- db: Chứa lược đồ CSDL và các phiên bản migration
  + schema.rb: Lược đồ CSDL
  + migrate: Các phiên bản migrate
  + seeds: Các dữ liệu khi khởi tạo ứng dụng
- Gemfile & Gemfile.lock: File cho phép quản lý, thêm bớt các Gem trong ứng dụng Rails
- log: Chứa các file log
- public: Chứa những file thông dụng cho một ứng dụng web. Những file HTML templates cho các lỗi HTTP như 404, 422 và 500. favicon và robots.txt
- README: Bản tóm tắt hướng dẫn sử dụng cho ứng dụng.
- test: Những file test cho ứng dụng
- vendor: Chứa file code từ bên thứ ba như các thư viện css. Javascript..

----------------------------------------

Migration:

- Rollback n version migrate: rake db:rollback STEP=3
- Run specify migrate version: rake db:migrate VERSION=<version-number>
- Table schema_migration : List những migration đã chạy - Nếu migration không có trong List -> run
- foreign_key: true/false : True -> Không thể xóa data khi có reference
- Rename column : rename_column :users, :oldname, :newname
- Khi chạy rake db:migrate sẽ invoke db:schema:dump -> update schema

def change
  change_column :users, :age, :string
end

----------------------------------------

Validation:

- before_create (any callback) -> false : Tất cả callback sẽ bị hủy. Các hành động trước đó Rollback

- acceptance checkbox khi form submit đã được check chưa? (Không cần lưu lại/Nếu không có field nào lưu helper tạo ra một virtual attribute để lưu)
- validates_associated validate model này và model associate với nó
- confirmation khi 2 trường cần khớp dữ liệu (password-pw-confirm/email-email-confirm)
- format : :format => { :with => /\A[a-zA-Z]+\z/, :message => "Only letters allowed" }
- inclusion value có thuộc trong set đã được liệt kê trước không?
- length (minimum/maximum/in/is)
- presence
- uniqueness :scope - :case_sensitive
- allow_nil / allow_blank
- on :on => :create / :on => :update
- numericality :only_integer


class ThisIsAValidator < ActiveModel::Validator
  def validate(record)
    if record.first.name == "Evil"
      record.errors[:base]
    end
  end
end

class Person < Applicationrecord
  validate_with ThisIsAValidator
end

//////////////

class User < ApplicationRecord
 validates :can_access_18plus, inclusion: { in: [false] }, if: can_not_access_18_area?

 def can_not_access_18_area?
  !self.is_admin && self.age < 18
 end
end
- length. Cách dùng: validates :password, length: { minimum: 6 } Có thể thay minimum: (Tối thiểu) bằng maximum: (Tối đa) / in: (Trong khoảng) / is: (Bằng)
- uniqueness. Cách dùng validates :email, uniqueness: true Có thể thêm symbol scope: (Một hoặc nhiều thuộc tính để giới hạn sự duy nhất trong gì đó vd như :year, :month) hoặc case_sensitive: (Bỏ qua hoặc sử dụng case_sensitive khi so sánh)
- presence. Cách dùng validates :username, presence: true - Dùng kiểm tra thuộc tính có rỗng hay không

//////////////

- acceptance: Kiểm tra giá trị của checkbox khi submit form - validates :terms_of_service, acceptance: true
- confirmation: So khớp giá trị của hai text field. validates :email, confirmation: true / Ở view templete sẽ có thêm trường email_confirmation
- exclusion/inclusion: Kiểm tra xem giá trị có thuộc trong bộ giá trị định sẵn không. validates :size, inclusion: { in: %w(small medium large) }

  :allow_nil Skip validation khi giá trị bằng nil. validates :phone_number, length: { in: 10..11 }, allow_nil: true
  :allow_blank Skip validation khi gía trị bỏ trống. validates :pin_code, length: Ơ í: 6 Ư, allow_blank: true
  :mesage Mesage sẽ được đưa vào éo collection.  validates :phone_number, length: Ơ in: 10..11 , mesage: "Phone number mút be 10 ỏ 11 number" Ư
  :on Chỉ định hành động được validate. validates :email, uniqueness: true, on: :create

- Check xem object có fail validation không? person.errors / person.errors.messages
- Check xem object có pass validation không? person.valid?

----------------------------------------

Association:

LƯU Ý:

//////////
- Với belongs_to : Khi thực hiện một thay đổi => phải call save mới thực hiện (a.user = User.find(1) => a.save)
- Với các mối quan hệ khác : Thay đối => autosave (u.accounts << Account.find(2))
//////////

has_many through: tạo ra một bảng trung gian khi liên kết giữa hai model
has_and_belongs_to liên kết trực tiếp hai model

Sử dụng has_many through: khi cần nơi để xử lý data trên dữ liệu liên kết giữa hai model/validation
Sử dụng has_and_belongs_to_many khi cần gọn nhẹ, quy mô nhỏ, không xử lý nhiều

Conditions: where/extending/group/include/limit/offset/order/readonly/select/distinct

class User < ApplicationRecord
 has_many :posts
end

class Post < ApplicationRecord
 belongs_to :user, class_name: "User", foreign_key: "people_id"
end

Với association: @post = @user.posts.create()
Không dùng association: @post = Post.create(user_id: @user.id)

Với association: @user.detroy
Không association:
@posts = Post.where(user_id: @user.id)
@posts.each do |post|
 post.destroy
end
@user.destroy

has_many :books , -> { where printed: true }

class Author < ApplicationRecord
has_many :books, { order "pusblished_at DESC" }
end

Chỉ định class sẽ lấy dữ liệu trong polymorphic association

class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :books, :through => :taggings, :source => :taggable, :source_type => "Book"
  has_many :movies, :through => :taggings, :source => :taggable, :source_type => "Movie"
end

class Tagging < ActiveRecord::Base
  belongs_to :taggable, :polymorphic => true
  belongs_to :tag
end

class Book < ActiveRecord::Base
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings
end

class Movie < ActiveRecord::Base
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings
end

Lấy ra các bộ phim có Tag là action
tag = tag.find_by_name("action")
tag.movies

Khi xóa Author sẽ xóa luôn các cuốn sách thuộc về Author đó
delete_all : xóa tất cả associated object ra khỏi database và không thể thực hiện callback
nullify : set foreign_key thành NULL, callback không thể thực hiện
restrict_with_exception : raise một exception khi tồn tại bất cứ asscociated record
restrict_with_error : nếu có record liên kết, sẽ thêm một error cho người sở hữu

assemblies_parts => thứ tự theo alphabet

class Assembly < ApplicationRecord
has_and_belongs_to_many :parts, join_table: this_is_the_name
end

class Part < ApplicationRecord
has_and_belongs_to_many :assemblies, join_table: this_is_the_name
end
end

class Employee < ApplicationRecord
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"

  belongs_to :manager, class_name: "Employee"
end

Quan hệ polymorphic :

  Define

  class Image < ...
    belongs_to :imageable, polymorphic: true
  end

  class User < ...
    has_many: :images, as: :imageable
  end

  Trong file migrate thêm refernce
    t.references :imageable, polymorphic: true, index: true

  Database thêm 2 field
    imageable_type : tên model sử dụng
    imageable_id : id của instance sở hữu

----------------------------

  Callbacks:

- Hàm nào skip validation nhưng chạy callback ? (toggle!/touch/update_attribute)
- Không có hàm nào chạy callback nhưng không validation
- Hủy các callback : throw(:abort)
- Callback chạy khi khởi tạo một ActiveRecord object : after_initialize
- Lưu ý Transaction Callbacks

----------------------------

  QueryInterface:

Class Product < ApplicationRecord
 scope :active { where(active: true) }
end

- Truyền gì vào params :order để gây ra SQL injection? => ' OR -- '/
- Hàm includes với hàm joins khác nhau chỗ nào?
- N + 1 query là gì? làm thế nào để tránh?
- Ý nghĩa của hàm .references và cho ví dụ
- Phân biệt left join và inner join

Client.where("first_name LIKE ?", params[:first_name])
Client.where("created_at >= :start_date AND created_at <= :end_date", {start_date: params[:start_date], end_date: params[:end_date]})

length sẽ load tất cả các object lên để đếm
count sẽ thực hiện việc đếm ở database
size sẽ kiểm tra xem object đã được load lên chưa, nếu true => trả về length mà không phải gọi tới database.Nếu false size sẽ kiểm tra counter_cache (nếu có). Nếu tất cả đều false size sẽ gọi đến count

distinct
offset



Context: User có nhiều bài post, 1 bài post có nhiều comment, 1 bài post có 1 column là lượt like (like_num)
1. Làm sao lấy ra tất cả User có post                       User.joins(:posts)
2. Làm sao lấy ra tất cả User có hoặc không có post đều đc  User.left_outer_joins(:posts)
3. Lấy tất cả User có bài post có like_num > 2              User.joins(:posts).where("posts.like_num > 2")
4. User.all.each do |u|
  puts u.posts
end

--> N + 1 query
Gỉai thích + Giải pháp
  Query ra tất cả user sau đó lấy ra các post của từng user đó
  => Dùng eager load : User.includes(:posts)


User.all.each do |u|
  u.posts.each do |p|
    puts p.comments
  end
end

--> N*M + 1 query
Gỉai thích + Giải pháp
Đầu tiên query ra tất cả user sau đó ở từng object user query ra tất cả các post rồi tiếp tục query để puts được các comment trong từng post
=> Dùng eager load : User.includes(post: :comments)

5. Cùng ngữ cảnh câu 4. Làm sao include được các bài post có like_num > 2
=> User.includes(:posts).where("posts.like_num > 2").references(:posts)

Trường hợp query trả về Array/nil/ActiveRelation/ActiveRelation nil

-----------------------------

  Routing:

- index / show / edit / new / create / update / destroy

- index (GET - /photos/)
- new (GET - /photos/new)
- edit (GET - /photos/:id/edit)
- update (PATCH/PUT - /photos/:id)
- create (POST - /photos)
- show (GET - /photos/:id)
- destroy (DELETE - /photos/:id)

Route /articles (without the prefix /admin)

scope module: 'admin' do
  resources :articles, :comments
end

or single case
  resources :articles, module: 'admin'

scope '/admin' do
  resources :articles, :comments
end

or resources: :articles, path: '/admin/articles'

- Shallow nesting :

    resources :articles, shallow: true do
      resources :comments
      resources :quotes
      resources :drafts
    end

- shallow_path => path
- shallow_prefix => helper

Adding member routes
  resources :photos do
    member do
      get 'preview'
    end
  end

- Redirection

  get '/stories', to: redirect('/articles')

Nested resource dùng để làm gì? => Khai báo đường dẫn cho các asociation
Theo đề nghị của Rails Guide thì chúng ta nên limit nested resource ở level thứ mấy (nên sử dụng bao nhiêu “resources” lồng nhau)? => Level 1, chỉ một resources lồng trong 1 resources khác


resources :posts do
  resources :comments
end

GET /posts/:post_id/comments post_comments_path
PATCH/PUT /post/:post_id/comments/:id  post_comments_path(:id)

get 'exit', to: 'sessions#destroy' => sẽ gọi đến sessions#destroy khi nhận được url /exit
get 'exit', to: 'sessions#destroy', as: :logout => tạo ra 2 helper logout_path và logout_url, gọi logout_path sẽ trả về /exit

match 'exit',  to: 'user#logout',  via: [:get, :post, :patch]

-------------------------------

  Controller:

- 2 kinds of parameter :
  + Query string parameters : everything after "?" in the URL
  + POST data

@post = Post.create(user_id = @user.id)
post = Post.where(user_id: 5)