module EinsteinEnum

  class Enum

    class << self

      def value(name, *types)
        if self == Enum
          raise 'Don\'t add values to Enum'
        end

        if !name.is_a?(Symbol)
          raise '`name` must be a symbol'
        end

        opts = {}
        if types.last.is_a?(Hash)
          opts = types.pop
        end

        new_value = EnumValue.new
        new_value.enum = self
        new_value.name = name
        new_value.types = types
        new_value.raw_value = opts[:raw_value] || (2 ** all_values.count)

        if existing_value = find(name, types)
          raise "There is already a value (#{existing_value}) that matches #{new_value}"
        end

        if all_values.any? { |existing_value| existing_value.raw_value == new_value.raw_value }
          raise "There is already a value (#{existing_value}) with the raw_value of `#{new_value.raw_value.inspect}`"
        end

        all_values << new_value

        if !self.respond_to?(name)
          define_singleton_method(name) do |*type_values|
            create(name, *type_values)
          end
          if types.count == 0
            self.const_set(name, new_value)
          end
          define_method(name) do |*type_values|
            self.class.create(name, *type_values)
          end
        end

        new_value
      end

      def all_values
        if self == Enum
          return []
        end

        @all_values ||= [] + self.superclass.all_values
      end

      def find(name, type_values)
        all_values.find do |enum_value|
          enum_value.name == name && types_match(enum_value.types, type_values)
        end
      end

      def types_match(types, type_values)
        if types.count != type_values.count
          false
        else
          matches = true
          if type_values.all? { |t| t.is_a?(Class) }
            types.each_with_index do |t, index|
              matches &&= type_values[index].ancestors.include?(t)
              break if not matches
            end
          else
            types.each_with_index do |t, index|
              matches &&= type_values[index].is_a?(t)
              break if not matches
            end
          end
          matches
        end
      end

      def create(name, *type_values)
        enum_value = find(name, type_values)
        if enum_value.nil?
          raise "could not find value for #{name}(#{type_values.map{|t|t.to_s}.join(', ')})"
        elsif !type_values.empty? && type_values.all? { |t| t.is_a?(Class) }
          return enum_value
        else
          return enum_value.instance(type_values)
        end
      end

    end

    attr_accessor :enum_value
    attr_accessor :values

    def ===(value)
      if value.is_a?(EnumValue)
        value.raw_value == raw_value
      elsif value.is_a?(Enum)
        value.enum_value.name == enum_value.name && value.values.count == values.count && begin
          matches = true
          values.each_with_index do |v, index|
            matches &&= v == value.values[index]
            break if not matches
          end
          matches
        end
      else
        false
      end
    end

    def raw_value
      enum_value.raw_value
    end

    def [](index)
      values[index]
    end

    def to_s
      "#{enum_value.name}(#{values.map{|t|t.to_s}.join(', ')})"
    end

  end


  class EnumValue
    attr_accessor :enum
    attr_accessor :name
    attr_accessor :types
    attr_accessor :raw_value

    def ===(value)
      if value.is_a?(EnumValue)
        value.raw_value == raw_value
      elsif value.is_a?(Enum)
        value.enum_value.name == name && Enum.types_match(types, value.values)
      else
        false
      end
    end

    def instance(values)
      instance = enum.new
      instance.enum_value = self
      instance.values = values
      instance
    end

    def to_s
      "#{name}(#{types.map{|t|t.to_s}.join(', ')})"
    end

  end
end


if !defined?(::Enum)
  Enum = EinsteinEnum::Enum
end
