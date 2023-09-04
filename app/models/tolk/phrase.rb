module Tolk
  class Phrase < ApplicationRecord
    self.table_name = 'tolk_phrases'

    default_scope { where("tolk_phrases.key LIKE 't\\_%'") }

    validates_uniqueness_of :key

    paginates_per 30

    has_many :translations, class_name: 'Tolk::Translation', dependent: :destroy do
      def primary
        to_a.detect { |t| t.locale_id == Tolk::Locale.primary_locale.id }
      end

      def for(locale)
        to_a.detect { |t| t.locale_id == locale.id }
      end
    end

    attr_accessor :translation

    # scope :red, -> { where(color: 'red') } rather than scope :red, -> { { conditions: { color: 'red' } } }

    scope :containing_text, lambda { |query|
      where("tolk_phrases.key LIKE 't\\_%#{query}'")
    }
  end
end
