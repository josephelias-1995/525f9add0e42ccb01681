class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :firstName, type: String
  field :lastName, type: String
  field :email, type: String
end
