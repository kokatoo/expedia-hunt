# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140303130252) do

  create_table "flights", :force => true do |t|
    t.string   "url",                                         :null => false
    t.decimal  "price",         :precision => 8, :scale => 2, :null => false
    t.string   "currency",                                    :null => false
    t.datetime "start",                                       :null => false
    t.datetime "end",                                         :null => false
    t.string   "source"
    t.string   "destination"
    t.integer  "search_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "sub_search_id"
  end

  add_index "flights", ["search_id"], :name => "index_flights_on_search_id"
  add_index "flights", ["sub_search_id"], :name => "index_flights_on_sub_search_id"

  create_table "searches", :force => true do |t|
    t.string   "title",                                                         :null => false
    t.datetime "start",                                                         :null => false
    t.integer  "min",                                                           :null => false
    t.integer  "max",                                                           :null => false
    t.string   "source"
    t.string   "destination"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.datetime "end"
    t.integer  "version",                                        :default => 0
    t.integer  "search_id"
    t.decimal  "avg_direct_price", :precision => 8, :scale => 2
  end

  add_index "searches", ["search_id"], :name => "index_searches_on_search_id"

  create_table "sub_searches", :force => true do |t|
    t.datetime "start",                                          :null => false
    t.datetime "end",                                            :null => false
    t.string   "source"
    t.string   "destination"
    t.integer  "search_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.decimal  "min_price",        :precision => 8, :scale => 2
    t.decimal  "max_price",        :precision => 8, :scale => 2
    t.decimal  "min_direct_price", :precision => 8, :scale => 2
    t.decimal  "max_direct_price", :precision => 8, :scale => 2
  end

  add_index "sub_searches", ["search_id"], :name => "index_sub_searches_on_search_id"

  create_table "temps", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "timelines", :force => true do |t|
    t.string   "airline"
    t.datetime "start",      :null => false
    t.datetime "end",        :null => false
    t.boolean  "layover",    :null => false
    t.string   "departure",  :null => false
    t.string   "arrival",    :null => false
    t.integer  "flight_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "timelines", ["flight_id"], :name => "index_timelines_on_flight_id"

end
