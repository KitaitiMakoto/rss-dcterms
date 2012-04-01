require 'rss'

module RSS
  DCTERMS_PREFIX = 'dcterms'
  DCTERMS_URI = "http://purl.org/dc/terms/"

  module BaseDCTERMSModel
    def append_features(klass)
      super

      return if klass.instance_of?(Module)
      DCTERMSModel::ELEMENT_NAME_INFOS.each do |name, plural_name|
        plural = plural_name || "#{name}s"
        full_name = "#{DCTERMS_PREFIX}_#{name}"
        full_plural_name = "#{DCTERMS_PREFIX}_#{plural}"
        klass_name = "DCTERMS#{Utils.to_class_name(name)}"
        klass.install_must_call_validator(DCTERMS_PREFIX, DCTERMS_URI)
        klass.install_have_children_element(name, DCTERMS_URI, "*",
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
          alias date_without_#{DCTERMS_PREFIX}_date= date=

          def date=(value)
            self.date_without_#{DCTERMS_PREFIX}_date = value
            self.#{DCTERMS_PREFIX}_date = value
          end
        else
          alias date #{DCTERMS_PREFIX}_date
          alias date= #{DCTERMS_PREFIX}_date=
        end
      EOC
    end
  end

  module DCTERMSModel

    extend BaseModel
    extend BaseDCTERMSModel

    TEXT_ELEMENTS = {
      "contributor" => nil,
      "creator" => nil,

      "coverage" => nil,
      "spatial" => nil,
      "temporal" => nil,

      "description" => nil,
      "abstract" => nil,
      "tableOfContents" => "tableOfContents_list",

      "format" => nil,
      "extent" => nil,
      "medium" => nil,

      "identifier" => nil,
      "bibliographicCitation" => nil,

      "language" => nil,

      "publisher" => nil,

      "relation" => nil,
      "source" => nil,
      "conformsTo" => nil,
      "hasFormat" => nil,
      "hasPart" => nil,
      "hasVersion" => nil,
      "isFormatOf" => nil,
      "isPartOf" => nil,
      "isReferencedBy" => nil,
      "isReplacedBy" => nil,
      "isRequiredBy" => nil,
      "isVersionOf" => nil,
      "references" => "references_list",
      "replaces" => "replaces_list",
      "requires" => "requires_list",

      "rights" => "rights_list",
      "accessRights" => "accessRights_list",
      "license" => nil,

      "subject" => nil,

      "title" => nil,
      "alternative" => nil,

      "type" => nil,

      "audience" => nil,
      "educationLevel" => nil,
      "mediator" => nil,

      "accrualMethod" => nil,
      "accrualPeriodicity" => nil,
      "accrualPolicy" => nil,
      "instructionalMethod" => nil,
      "provenance" => nil,
      "rightsHolder" => nil
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

    ELEMENT_NAME_INFOS = DCTERMSModel::TEXT_ELEMENTS.to_a
    DCTERMSModel::DATE_ELEMENTS.each do |name, |
      ELEMENT_NAME_INFOS << [name, nil]
    end

    ELEMENTS = TEXT_ELEMENTS.keys + DATE_ELEMENTS.keys

    ELEMENTS.each do |name, plural_name|
      module_eval(<<-EOC, *get_file_and_line_from_caller(0))
        class DCTERMS#{Utils.to_class_name(name)} < Element
          include RSS10

          content_setup

          class << self
            def required_prefix
              DCTERMS_PREFIX
            end

            def required_uri
              DCTERMS_URI
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
            tag_name_with_prefix(DCTERMS_PREFIX)
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
      tag_name = "#{DCTERMS_PREFIX}:#{name}"
      module_eval(<<-EOC, *get_file_and_line_from_caller(0))
        class DCTERMS#{Utils.to_class_name(name)} < Element
          remove_method(:content=)
          remove_method(:value=)

          date_writer("content", #{type.dump}, #{tag_name.dump})

          alias_method(:value=, :content=)
        end
      EOC
    end
  end

  DCTERMSModel::ELEMENTS.each do |name|
    class_name = Utils.to_class_name(name)
    BaseListener.install_class_name(DCTERMS_URI, name, "DCTERMS#{class_name}")
  end

  DCTERMSModel::ELEMENTS.collect! {|name| "#{DCTERMS_PREFIX}_#{name}"}
end

module RSS
  module Utils
    module_function

    def to_attr_name(name)
      name.gsub(/([A-Z])/) {'_' + $1.downcase}
    end
  end

  module Atom
    Feed.install_ns(DCTERMS_PREFIX, DCTERMS_URI)

    class Feed
      include DCTERMSModel
      class Entry; include DCTERMSModel; end
    end

    class Entry
      include DCTERMSModel
    end
  end
end
