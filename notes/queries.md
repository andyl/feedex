# Queries

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

