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

ActiveRecord::Schema.define(version: 20170627163604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "business_places", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_products", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "product_id"
    t.string   "comment"
  end

  create_table "business_sucursals", force: :cascade do |t|
    t.integer  "business_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name"
    t.integer  "phone"
    t.string   "address_description"
    t.integer  "address_latitude"
    t.integer  "address_longitude"
    t.integer  "coins",               default: 0
    t.integer  "order_count",         default: 0
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "categorie_type", default: 0
    t.integer  "categorie_id",   default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "charges", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "type_id"
  end

  create_table "credit_note_items", force: :cascade do |t|
    t.integer  "note_id"
    t.integer  "product_id"
    t.float    "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credit_notes", force: :cascade do |t|
    t.integer  "consecutive"
    t.integer  "order_id"
    t.float    "total"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "order_lists", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_products", force: :cascade do |t|
    t.integer  "order_id",      default: 0
    t.float    "price",         default: 0.0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "comment"
    t.float    "quantity"
    t.integer  "variant_id"
    t.integer  "status",        default: 0
    t.float    "last_quantity", default: 0.0
    t.integer  "provider_id"
    t.float    "iva"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "status",       default: 0
    t.integer  "order_type",   default: 0
    t.boolean  "isLate",       default: false
    t.float    "calification", default: 0.0
    t.integer  "pay_mode",     default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "comment"
    t.datetime "datehour"
    t.integer  "target_id"
    t.integer  "consecutive"
    t.float    "total",        default: 0.0
  end

  create_table "product_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "type",       default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "product_variants", force: :cascade do |t|
    t.string   "name"
    t.float    "entry_price"
    t.integer  "coin_price",       default: 0
    t.float    "discount",         default: 0.0
    t.float    "default_quantity"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.uuid     "uuid",             default: -> { "uuid_generate_v4()" }
    t.integer  "product_id"
    t.float    "business_percent"
    t.float    "business_gain"
    t.float    "natural_percent"
    t.float    "natural_gain"
    t.float    "unit_measurement", default: 0.0
    t.integer  "enabled",          default: 0
    t.string   "description"
    t.float    "iva"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.uuid     "uuid",             default: -> { "uuid_generate_v4()" }
    t.integer  "measurement_type"
    t.integer  "subcategorie_id"
    t.integer  "enabled",          default: 0
  end

  create_table "providers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
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
    t.boolean  "can_login_app_business",       default: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "can_create_business_place",    default: false
    t.boolean  "can_create_business_sucursal", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password"
    t.string   "address_description"
    t.float    "address_latitude"
    t.float    "address_longitude"
    t.integer  "frepi_coins",         default: 0
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.boolean  "active",              default: false
    t.string   "name"
    t.string   "lastname"
    t.uuid     "uuid",                default: -> { "uuid_generate_v4()" }
    t.bigint   "phone",               default: 0
    t.integer  "order_count",         default: 0
  end

end
