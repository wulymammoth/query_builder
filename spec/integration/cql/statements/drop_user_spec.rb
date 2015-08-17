# encoding: utf-8

describe QueryBuilder::CQL, ".drop_user" do

  let(:statement) { described_class.drop_user(:foo) }

  it_behaves_like :query_builder do
    subject   { statement }
    let(:cql) { "DROP USER foo;" }
  end

  it_behaves_like :query_builder do
    subject   { statement.if_exists.if_exists }
    let(:cql) { "DROP USER IF EXISTS foo;" }
  end

end # describe QueryBuilder::CQL.drop_user