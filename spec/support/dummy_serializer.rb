# frozen_string_literal: true

class DummyKeyFormatter
  def format(key)
    key
  end
end

class DummySerializer
  def key_formatter
    DummyKeyFormatter.new
  end
end
