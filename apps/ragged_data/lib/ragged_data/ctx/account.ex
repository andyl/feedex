defmodule RaggedData.Ctx.Account do
  alias RaggedData.Ctx.Account.{User, Folder, Register, ReadLog}
  alias RaggedData.Repo
  alias Modex.AltMap
  import Ecto.Query

  # ----- users -----

  def user_list do
    Repo.all(User)
  end

  def user_get(user_id) do
    Repo.get(User, user_id)
  end

  def user_get_by(params) do
    Repo.get_by(User, params)
  end

  def user_add(opts) do
    %User{}
    |> User.changeset(opts)
    |> Repo.insert()
  end

  def user_signup(opts) do
    %User{}
    |> User.signup_changeset(opts)
    |> Repo.insert()
  end

  def user_changeset(%User{} = user) do
    User.changeset(user, %{})
  end

  def user_change(_user_id) do
  end

  def user_change_pwd(_user_id, _newpwd) do
  end

  def user_delete(_user_id) do
  end

  def user_auth_by_email_and_pwd(email, pwd) do
    user = user_get_by(email: email)

    cond do
      user && Pbkdf2.verify_pass(pwd, user.pwd_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  # ----- tree -----

  def cleantree(user_id) do
    rawtree(user_id) 
    |> AltMap.retake([:id, :name, :user_id, :registers])
  end

  def rawtree(user_id) do
    rq = from(r in Register, select: %{id: r.id, name: r.name})
      
    from(
      f in Folder,
      where: f.user_id == ^user_id,
      preload: [registers: ^rq]
    )
    |> Repo.all()
  end

  # ----- folders -----

  def folder_add do
  end

  def folder_get(id) do
    Repo.get(Folder, id)
  end

  def folder_update do
  end

  def folder_delete do
  end
  
  # ----- registers -----

  def register_get(id) do
    Repo.get(Register, id)
  end
  
  # ----- mark-read -----

  @doc """
  Mark posts read.  Idempotent.
  """
  def mark_read(_user_id) do
    IO.puts "mark_read ALL"
  end

  def mark_read(_user_id, fld_id: _fld_id) do
    IO.puts "mark_read fld_id"
  end

  def mark_read(_user_id, reg_id: _reg_id) do
    IO.puts "mark_read reg_id"
  end

  def mark_read(user_id, pst_id: post_id) do
    qry = 
      """
      update registers set read_list = read_list || '#{post_id}' 
      where not(read_list @> '#{post_id}')
      and id in (
      select reg.id
      from folders fld
      join registers reg on fld.id = reg.folder_id
      join feeds fee     on fee.id = reg.feed_id 
      join posts pst     on fee.id = pst.feed_id
      where fld.user_id = #{user_id} and pst.id = #{post_id}
      order by reg.id
      )
      """
    mk2(user_id, pst_id: post_id)
    RaggedData.Repo.query(qry)
  end

  def mk2(user_id, pst_id: post_id) do
    %ReadLog{}
    |> ReadLog.changeset(read_log_ids(user_id, post_id))
    |> Repo.insert()
  end

  def read_log_ids(user_id, post_id) do
    from(pst in "posts",
      join: fee in "feeds", on: pst.feed_id == fee.id,
      join: reg in "registers", on: reg.feed_id == fee.id,
      where: pst.id == ^post_id,
      select: %{folder_id: reg.folder_id, register_id: reg.id}
    ) 
    |> Repo.one() 
    |> Map.merge(%{user_id: user_id, post_id: post_id})
  end
  
  # ----- feeds ----- 

  # def feed_add do
  # end
  #
  # def feed_update do
  # end
  #
  # def feed_delete do
  # end

  # ----- utility functions -----

  @doc """
  Count number of elements in the database.
  """
  def count do
    %{
      user: count(User),
      folder: count(Folder),
      register: count(Register)
    }
  end

  def count(type) do
    from(element in type, select: count(element.id))
    |> Repo.one()
  end
end
