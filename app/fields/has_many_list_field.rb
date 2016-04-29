require "administrate/field/base"

class HasManyListField < Administrate::Field::Base
  def to_s
    title
  end
end
