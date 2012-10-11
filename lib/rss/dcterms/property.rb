module RSS
  module DCTerms
    module BasePropertyModel
      def append_features(klass)
        super

        return if klass.instance_of?(Module)
        PropertyModel::ELEMENT_NAME_INFOS.each do |name, plural_name|
          plural = plural_name || "#{name}s"
          full_name = "#{PREFIX}_#{name}"
          full_plural_name = "#{PREFIX}_#{plural}"
          klass_name = "DCTerms#{Utils.to_class_name(name)}"
          klass.install_must_call_validator(PREFIX, URI)
          klass.install_have_children_element(name, URI, "*",
                                              full_name, full_plural_name)
          klass.module_eval(<<-EOC, *get_file_and_line_from_caller(0))
            remove_method :#{full_name}
            remove_method :#{full_name}=
            remove_method :set_#{full_name}

            def #{full_name}
              @#{full_name}.first and @#{full_name}.first.value
            end
            alias #{to_attr_name(full_name)} #{full_name}

            def #{full_name}=(new_value)
              @#{full_name}[0] = Utils.new_with_value_if_need(#{klass_name}, new_value)
            end
            alias set_#{full_name} #{full_name}=
            alias #{to_attr_name(full_name)}= #{full_name}=
            alias set_#{to_attr_name(full_name)} #{full_name}=

            alias #{to_attr_name(full_plural_name)} #{full_plural_name}
          EOC
        end
        klass.module_eval(<<-EOC, *get_file_and_line_from_caller(0))
          if method_defined?(:date)
            alias date_without_#{PREFIX}_date= date=

            def date=(value)
              self.date_without_#{PREFIX}_date = value
              self.#{PREFIX}_date = value
            end
          else
            alias date #{PREFIX}_date
            alias date= #{PREFIX}_date=
          end
        EOC
      end
    end

    module PropertyModel

      extend BaseModel
      extend BasePropertyModel

      TEXT_ELEMENTS = {
        "contributor" => nil,
        "creator"     => nil,

        "coverage" => nil,
        "spatial"  => nil,
        "temporal" => nil,

        "description"     => nil,
        "abstract"        => nil,
        "tableOfContents" => "tableOfContents_list",

        "format" => nil,
        "extent" => nil,
        "medium" => nil,

        "identifier"            => nil,
        "bibliographicCitation" => nil,

        "language" => nil,

        "publisher" => nil,

        "relation"       => nil,
        "source"         => nil,
        "conformsTo"     => nil,
        "hasFormat"      => nil,
        "hasPart"        => nil,
        "hasVersion"     => nil,
        "isFormatOf"     => nil,
        "isPartOf"       => nil,
        "isReferencedBy" => nil,
        "isReplacedBy"   => nil,
        "isRequiredBy"   => nil,
        "isVersionOf"    => nil,
        "references"     => "references_list",
        "replaces"       => "replaces_list",
        "requires"       => "requires_list",

        "rights"       => "rights_list",
        "accessRights" => "accessRights_list",
        "license"      => nil,

        "subject" => nil,

        "title"       => nil,
        "alternative" => nil,

        "type" => nil,

        "audience"       => nil,
        "educationLevel" => nil,
        "mediator"       => nil,

        "accrualMethod"       => nil,
        "accrualPeriodicity"  => nil,
        "accrualPolicy"       => nil,
        "instructionalMethod" => nil,
        "provenance"          => nil,
        "rightsHolder"        => nil
      }

      DATE_ELEMENTS = {
        "date" => "w3cdtf",
        "available" => "w3cdtf",
        "created" => "w3cdtf",
        "dateAccepted" => "w3cdtf",
        "dateCopyrighted" => "w3cdtf",
        "dateSubmitted" => "w3cdtf",
        "issued" => "w3cdtf",
        "modified" => "w3cdtf",
        "valid" => "w3cdtf"
      }

      ELEMENT_NAME_INFOS = PropertyModel::TEXT_ELEMENTS.to_a
      PropertyModel::DATE_ELEMENTS.each do |name, |
        ELEMENT_NAME_INFOS << [name, nil]
      end

      ELEMENTS = TEXT_ELEMENTS.keys + DATE_ELEMENTS.keys

      ELEMENTS.each do |name, plural_name|
        module_eval(<<-EOC, *get_file_and_line_from_caller(0))
          class DCTerms#{Utils.to_class_name(name)} < Element
            include RSS10

            content_setup

            class << self
              def required_prefix
                PREFIX
              end

              def required_uri
                URI
              end
            end

            @tag_name = #{name.dump}

            alias_method(:value, :content)
            alias_method(:value=, :content=)

            def initialize(*args)
              if Utils.element_initialize_arguments?(args)
                super
              else
                super()
                self.content = args[0]
              end
            end

            def full_name
              tag_name_with_prefix(PREFIX)
            end

            def maker_target(target)
              target.new_#{name}
            end

            def setup_maker_attributes(#{name})
              #{name}.content = content
            end
          end
        EOC
      end

      DATE_ELEMENTS.each do |name, type|
        tag_name = "#{PREFIX}:#{name}"
        module_eval(<<-EOC, *get_file_and_line_from_caller(0))
          class DCTerms#{Utils.to_class_name(name)} < Element
            remove_method(:content=)
            remove_method(:value=)

            date_writer("content", #{type.dump}, #{tag_name.dump})

            alias_method(:value=, :content=)
          end
        EOC
      end
    end

    DCTerms::PropertyModel::ELEMENTS.each do |name|
      class_name = Utils.to_class_name(name)
      BaseListener.install_class_name(URI, name, class_name)
    end

    DCTerms::PropertyModel::ELEMENTS.collect! {|name| "#{PREFIX}_#{name}"}
  end
end
