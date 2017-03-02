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

ActiveRecord::Schema.define(version: 20170302001400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "business_places", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_products", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "quantity"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "product_id"
    t.integer  "type_measure"
  end

  create_table "business_sucursals", force: :cascade do |t|
    t.integer  "business_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "name"
    t.integer  "phone"
    t.string   "address_description"
    t.integer  "address_latitude"
    t.integer  "address_longitude"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "categorie_type", default: 0
    t.integer  "categorie_id",   default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "order_products", force: :cascade do |t|
    t.integer  "order_id",     default: 0
    t.integer  "product_id",   default: 0
    t.float    "price",        default: 0.0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.string   "comment"
    t.integer  "quantity"
    t.integer  "measure_type"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",             default: 0
    t.integer  "status",              default: 0
    t.integer  "order_type",          default: 0
    t.boolean  "isLate",              default: false
    t.integer  "frepiman_id",         default: 0
    t.integer  "shopper_id",          default: 0
    t.float    "calification",        default: 0.0
    t.date     "date"
    t.time     "hour"
    t.float    "paid",                default: 0.0
    t.float    "due",                 default: 0.0
    t.float    "interest",            default: 0.0
    t.date     "interest_date_max"
    t.integer  "interest_delay_days", default: 0
    t.integer  "pay_mode",            default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "product_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "type",       default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "group_id",            default: 0
    t.float    "entry_price",         default: 0.0
    t.float    "natural_price",       default: 0.0
    t.float    "business_price",      default: 0.0
    t.integer  "subcategorie_id",     default: 0
    t.boolean  "enabled",             default: true
    t.integer  "coin_price",          default: 0
    t.float    "discount",            default: 0.0
    t.integer  "provider_may_id",     default: 0
    t.integer  "provider_min_id",     default: 0
    t.integer  "type_size",           default: 0
    t.integer  "cant_min_may",        default: 0
    t.integer  "product_count",       default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "type_measure"
    t.string   "measure_description"
  end

  create_table "tokens", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_types", force: :cascade do |t|
    t.string   "name"
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
    t.boolean  "active",               default: false
    t.string   "name"
    t.string   "lastname"
    t.integer  "sucursal_id",          default: 0
    t.integer  "phone"
  end

end
