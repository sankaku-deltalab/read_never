# Database design

```md
example

## Context-Name

- TableName (description)
  - attribute (optional description)

```

## BookShelf

- BooksDirectory (Directory contain book files)
  - directory_path
  - name
- Book (Book file)
  - filepath
  - name
  - last_read_datetime
  - books_directory_id
- BookPriorityChangeLog (Log of book priority change)
  - book_id
  - change_datetime
  - priority (new / reading / read_next / read_later / read_never)
- BookTag (Tag of books)
  - name
- BookAndBookTagJoin (Join table)
  - book_id
  - book_tag_id

---

```bash
mix phx.gen.live BookShelf BooksDirectory books_directories directory_path:string:unique name:string
mix phx.gen.live BookShelf Book books filepath:string:unique name:string last_read_datetime:utc_datetime books_directory_id:references:books_directories
mix phx.gen.live BookShelf BookPriorityChangeLog book_priority_changelog book_id:references:books change_datetime:utc_datetime priority:enum:new:reading:read_next:read_later:read_never
mix phx.gen.live BookShelf BookTag book_tags name:string:unique
```
