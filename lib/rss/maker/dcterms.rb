require 'rss/dcterms'
require 'rss/maker'

module RSS
  module Maker
    module DCTerms
      module PropertyModel
        class << self
          def append_features(klass)
            super

            ::RSS::DCTerms::PropertyModel::ELEMENT_NAME_INFOS.each do |name, plural_name|
              plural_name ||= "#{name}s"
              full_name = "#{RSS::DCTerms::PREFIX}_#{name}"
              full_plural_name = "#{RSS::DCTerms::PREFIX}_#{plural_name}"
              plural_klass_name = "DCTerms#{Utils.to_class_name(plural_name)}"
              klass.def_classed_elements full_name, 'value', plural_klass_name,
                                         full_plural_name, name
              klass.module_eval(<<-EOC)
                def new_#{full_name}(value=nil)
                  _#{full_name} = #{full_plural_name}.new_#{name}
                  _#{full_name}.value = value
                  if block_given?
                    yield _#{full_name}
                  else
                    _#{full_name}
                  end
                end
              EOC
            end
          end

          def install_dcterms_core(klass)
            ::RSS::DCTerms::PropertyModel::ELEMENT_NAME_INFOS.each do |name, plural_name|
              plural_name ||= "#{name}s"
              klass_name = Utils.to_class_name(name)
              full_klass_name = "DCTerms#{klass_name}"
              plural_klass_name = "DCTerms#{Utils.to_class_name(plural_name)}"
              klass.module_eval(<<-EOC, __FILE__, __LINE__ + 1)
              class #{plural_klass_name} < #{plural_klass_name}Base
                class #{full_klass_name} < #{full_klass_name}Base
                end
                #{klass_name} = #{full_klass_name}
              end
EOC
            end
          end
        end

        ::RSS::DCTerms::PropertyModel::ELEMENT_NAME_INFOS.each do |name, plural_name|
          plural_name ||= "#{name}s"
          full_name = "#{RSS::DCTerms::PREFIX}_#{name}"
          full_plural_name = "#{RSS::DCTerms::PREFIX}_#{plural_name}"
          klass_name = Utils.to_class_name(name)
          full_klass_name = "DCTerms#{klass_name}"
          plural_klass_name = "DCTerms#{Utils.to_class_name(plural_name)}"
          module_eval(<<-EOC, __FILE__, __LINE__ + 1)
          class #{plural_klass_name}Base < Base
            def_array_element #{name.dump}, #{full_plural_name.dump},
                              #{full_klass_name.dump}

            class #{full_klass_name}Base < Base
              attr_accessor :value
              add_need_initialize_variable 'value'
              alias_method :content, :value
              alias_method :content=, :value=

              def have_required_values?
                @value
              end

              def to_feed(feed, current)
                if value and current.respond_to? :#{full_name}
                  new_item = current.class::#{full_klass_name}.new(value)
                  current.#{full_plural_name} << new_item
                end
              end
            end
            #{klass_name}Base = #{full_klass_name}Base
          end
          EOC
        end
      end
    end

    class ChannelBase
      include DCTerms::PropertyModel
    end

    class ImageBase; include DCTerms::PropertyModel; end
    class ItemsBase
      class ItemBase
        include DCTerms::PropertyModel
      end
    end
    class TextinputBase; include DCTerms::PropertyModel; end

    makers.each do |maker|
      maker.module_eval(<<-EOC, __FILE__, __LINE__ + 1)
        class Channel
          DCTerms::PropertyModel.install_dcterms_core self
        end

        class Image
          DCTerms::PropertyModel.install_dcterms_core self
        end

        class Items
          class Item
            DCTerms::PropertyModel.install_dcterms_core self
          end
        end

        class Textinput
          DCTerms::PropertyModel.install_dcterms_core self
        end
      EOC
    end
  end
end
