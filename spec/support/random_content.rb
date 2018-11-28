# frozen_string_literal: true

def generate_id
  r = ('a'..'z').to_a + ('0'..'9').to_a

  Array(10).map { r.sample }.join
end

def random_content(size = 10)
  content = []

  # Root content item
  root = {
    :id => generate_id,
    :type => 'contentItemTypes/ROOT',
    :childItemIds => []
  }

  # Add root to content
  content << root

  size.times.each do
    content_item = if [true, false].sample
                     {
                       :id => generate_id,
                       :type => 'contentItemTypes/PARAGRAPH',
                       :text => Faker::Lorem.words(60).join(' ')
                     }
                   else
                     {
                       :id => generate_id,
                       :type => 'contentItemTypes/HEADING',
                       :text => Faker::Lorem.words(8).join(' ')
                     }
                   end

    # Add content item to content and reference from root content item
    root[:childItemIds] << content_item[:id]
    content << content_item
  end

  # Return content
  content
end
