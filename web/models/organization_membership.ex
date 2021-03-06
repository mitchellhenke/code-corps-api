defmodule CodeCorps.OrganizationMembership do
  @moduledoc """
  Represents a membership of a user in an organization.
  """

  use CodeCorps.Web, :model

  import CodeCorps.ModelHelpers

  schema "organization_memberships" do
    field :role, :string

    belongs_to :organization, CodeCorps.Organization
    belongs_to :member, CodeCorps.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`, for creating a record.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:member_id, :organization_id])
    |> validate_required([:member_id, :organization_id])
    |> assoc_constraint(:member)
    |> assoc_constraint(:organization)
    |> put_change(:role, "pending")
  end

  @doc """
  Builds a changeset based on the `struct` and `params`, for updating a record.
  """
  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:role])
    |> validate_required([:role])
    |> validate_inclusion(:role, roles)
  end

  def index_filters(query, params) do
    query
    |> id_filter(params)
    |> organization_filter(params)
    |> role_filter(params)
  end

  defp roles do
    ~w{ pending contributor admin owner }
  end
end
