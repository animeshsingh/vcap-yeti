require "harness"
require "spec_helper"

describe "Domains", :runtime => true do
  before { @session = BVT::Harness::CFSession.new }

  after { @session.cleanup! }

  it "cannot be created with duplicate names" do
    new_domain = "random-domain-#{SecureRandom.uuid}.some-domain.com"

    domain = make_domain(new_domain)
    domain.create!

    expect {
      domain.create!
    }.to raise_error(/The domain name is taken/)
  end

  it "can be used for an app's routes" do
    new_domain = "random-domain-#{SecureRandom.uuid}.some-domain.com"

    app = make_app
    app.create!

    domain = make_domain(new_domain)
    domain.create!

    app.space.add_domain(domain)

    route = map_route(app, SecureRandom.uuid, domain)

    app.upload(asset("sinatra/dora"))
    app.start!(&staging_callback)

    wait do
      stats = app.stats
      expect(stats).to include("0")
      expect(stats["0"]).to include(:stats)
      expect(stats["0"][:stats][:uris]).to eq([route.name])
    end
  end

  context "when there are routes using the domain" do
    it "cannot be deleted" do
      new_domain = "random-domain-#{SecureRandom.uuid}.some-domain.com"

      domain = make_domain(new_domain)
      domain.create!

      @session.current_space.add_domain(domain)

      route = make_route(domain)
      route.create!

      expect {
        domain.delete!
      }.to raise_error(
     CFoundry::AssociationNotEmpty, /Domain is not empty. To delete, please remove the following associations: routes./
      )

      route.delete!

      expect { domain.delete! }.to_not raise_error
    end
  end
end
