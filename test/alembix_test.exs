defmodule AlembixTest do
  use ExUnit.Case
  doctest Alembix

  setup_all do
    System.put_env("ALEMBIC_TEST", "value")
    System.put_env("ALEMBIC_TEST_BOOLEAN", "true")
    System.put_env("ALEMBIC_TEST_ATOM", "test")
    System.put_env("ALEMBIC_TEST_INTEGER", "12")
    System.put_env("ALEMBIC_TEST_BASE16", "8F3Aa15557ec46093Abe4B910Fdc6CDCD2aDc07f")
  end

  test "succeed with existing env varibale" do
    assert "value" == Alembix.fetch_env!("ALEMBIC_TEST")
    assert true == Alembix.fetch_boolean!("ALEMBIC_TEST_BOOLEAN")
    assert :test == Alembix.fetch_atom!("ALEMBIC_TEST_ATOM")
    assert 12 == Alembix.fetch_integer!("ALEMBIC_TEST_INTEGER")

    assert <<143, 58, 161, 85, 87, 236, 70, 9, 58, 190, 75, 145, 15, 220, 108, 220, 210, 173, 192,
             127>> ==
             Alembix.fetch_base_16!("ALEMBIC_TEST_BASE16")
  end

  test "fetch_boolean fail if not boolean" do
    assert_raise(
      RuntimeError,
      fn ->
        Alembix.fetch_boolean!("ALEMBIC_TEST")
      end
    )
  end

  test "raise when missing value" do
    assert_raise(
      RuntimeError,
      fn ->
        Alembix.fetch_env!("NOT_EXISTANT")
      end
    )

    assert_raise(
      RuntimeError,
      fn ->
        Alembix.fetch_boolean!("NOT_EXISTANT")
      end
    )

    assert_raise(
      RuntimeError,
      fn ->
        Alembix.fetch_base_16!("ALEMBIC_TEST")
      end
    )
  end
end
