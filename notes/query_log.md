# Query Log

Problems:
- preloading
- joins
- calculating report values (subcalculations)
- efficient / minimal outputs
- nested return values
- preload and select don't seem to work together

Hack / Workaround
- retake - recursive take

Questions:
- What is a CTE?
- How do sub-queries work?
- How to convert subqueries to hierarchical maps?
- How to use Embedded Schemas?

NS
- retake SQL class
- re-read SQL book
- re-read ECTO book

## 2019 Aug 13 Tue

- [x] Wrote retake - recursive take

## 2019 Aug 14 Wed

- [x] Failed to generate desired results with Ecto

## CleanTree 1

simple list of folders

```
[
  %{
    id: 44,
    name: "Folder1",
    feed_logs: [
      %{
        id: 22,
        name: "Feedlog1"
        }
    ]
  },
  %{
    id: 45,
    name: "Folder1",
    feed_logs: [
      %{
        id: 23,
        name: "Feedlog3"
        }
    ]
  }
]

```

## CleanTree 2

simple list of folders with read/unread counts

```
[
  %{
    id: 44,
    name: "Folder1",
    post_new: 3,
    post_cnt: 22,
    feed_logs: [
      %{
        id: 22,
        name: "Feedlog1",
        post_new: 3,
        post_cnt: 22,
        }
    ]
  },
  %{
    id: 45,
    name: "Folder1",
    post_new: 3,
    post_cnt: 22,
    feed_logs: [
      %{
        id: 23,
        name: "Feedlog3",
        post_new: 3,
        post_cnt: 22,
        }
    ]
  }
]

```
