require 'ERB'
require "minitest/autorun"

class Tags
  module ClassMethods
    def all
      [text_field, text_area].flatten
    end

    protected
    def generator(hash_params)
      ->(&block) do
        [
          <<~ERB.split("\n"),
            <%=
              render partial: 'パーシャル', locals: {
                title: '#{hash_params.fetch(:title)}',
                class: '#{hash_params.fetch(:class)}'
              } do
            %>
          ERB
          block.().split("\n").map{|item| "\s\s#{item}"},
          <<~ERB.split("\n"),
            <% end %>
          ERB
        ]
      end
    end

    def text_field
      params = { title: 'テキストフィールド', class: 'ブラック' }
      wrap_tag = generator(params)
      wrap_tag.call do
        <<~ERB
          <%= f.text_field :name %>
        ERB
      end
    end

    def text_area
      params = { title: 'テキストエリア', class: 'ホワイト' }
      wrap_tag = generator(params)
      wrap_tag.call do
        <<~ERB
          <%= f.text_area :name %>
        ERB
      end
    end
  end

  extend ClassMethods
end

class TestMeme < Minitest::Test
  def setup
    @template = ERB.new(<<~ERB, trim_mode: '%-')
      <%% end %>
        <%- array.each do |item| -%>
        <%= item %>
        <%- end -%>
      <%% if true %>
    ERB
  end

  def test_stdout
    assert_output(<<~ERB){ print @template.result_with_hash(array: Tags.all) }
      <% end %>
        <%=
          render partial: 'パーシャル', locals: {
            title: 'テキストフィールド',
            class: 'ブラック'
          } do
        %>
          <%= f.text_field :name %>
        <% end %>
        <%=
          render partial: 'パーシャル', locals: {
            title: 'テキストエリア',
            class: 'ホワイト'
          } do
        %>
          <%= f.text_area :name %>
        <% end %>
      <% if true %>
    ERB
  end
end