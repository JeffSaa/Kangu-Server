# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170201154707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "business_places", force: :cascade do |t|
    t.string   "name"
    t.string   "domain"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_sucursals", force: :cascade do |t|
    t.integer  "business_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name"
    t.string   "domain"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "business_id",                  default: 0
    t.boolean  "can_login_app_business",       default: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "can_create_business_place",    default: false
    t.boolean  "can_create_business_sucursal", default: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "type_id",              default: 0
    t.string   "email"
    t.string   "password"
    t.string   "address_description"
    t.float    "address_latitude"
    t.float    "address_longitude"
    t.boolean  "have_custom_products", default: false
    t.integer  "frepi_coins",          default: 0
    t.integer  "quota_max",            default: 0
    t.integer  "current_quota",        default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "user_group_id",        default: 0
  end

end
