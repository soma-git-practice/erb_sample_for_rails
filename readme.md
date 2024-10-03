# 以下のようにインデントが整ったERBを表示する

```ruby
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
```