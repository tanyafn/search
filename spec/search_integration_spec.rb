# frozen_string_literal: true

RSpec.describe 'Search integration' do
  let!(:users_json)         { JsonFileReader.read('./spec/support/data/users.json') }
  let!(:tickets_json)       { JsonFileReader.read('./spec/support/data/tickets.json') }
  let!(:organizations_json) { JsonFileReader.read('./spec/support/data/organizations.json') }

  let(:expected_result_json) do
    <<-JSON
      [{
      	"_id": 1,
      	"url": "http://initech.zendesk.com/api/v2/users/1.json",
      	"external_id": "74341f74-9c79-49d5-9611-87ef9b6eb75f",
      	"name": "Francisca Rasmussen",
      	"alias": "Miss Coffey",
      	"created_at": "2016-04-15T05:19:46 -10:00",
      	"active": true,
      	"verified": true,
      	"shared": false,
      	"locale": "en-AU",
      	"timezone": "Sri Lanka",
      	"last_login_at": "2013-08-04T01:03:27 -10:00",
      	"email": "coffeyrasmussen@flotonic.com",
      	"phone": "8335-422-718",
      	"signature": "Don't Worry Be Happy!",
      	"organization_id": 119,
      	"tags": ["Springville", "Sutton", "Hartsville/Hartley", "Diaperville"],
      	"suspended": true,
      	"role": "admin",
      	"organization": {
      		"_id": 119,
      		"url": "http://initech.zendesk.com/api/v2/organizations/119.json",
      		"external_id": "2386db7c-5056-49c9-8dc4-46775e464cb7",
      		"name": "Multron",
      		"domain_names": ["bleeko.com", "pulze.com", "xoggle.com", "sultraxin.com"],
      		"created_at": "2016-02-29T03:45:12 -11:00",
      		"details": "Non profit",
      		"shared_tickets": false,
      		"tags": ["Erickson", "Mccoy", "Wiggins", "Brooks"]
      	},
      	"submitted_tickets": [{
      		"_id": "fc5a8a70-3814-4b17-a6e9-583936fca909",
      		"url": "http://initech.zendesk.com/api/v2/tickets/fc5a8a70-3814-4b17-a6e9-583936fca909.json",
      		"external_id": "e8cab26b-f3b9-4016-875c-b0d9a258761b",
      		"created_at": "2016-07-08T07:57:15 -10:00",
      		"type": "problem",
      		"subject": "A Nuisance in Kiribati",
      		"description": "Ipsum reprehenderit non ea officia labore aute. Qui sit aliquip ipsum nostrud anim qui pariatur ut anim aliqua non aliqua.",
      		"priority": "high",
      		"status": "open",
      		"submitter_id": 1,
      		"assignee_id": 19,
      		"organization_id": 120,
      		"tags": ["Minnesota", "New Jersey", "Texas", "Nevada"],
      		"has_incidents": true,
      		"via": "voice"
      	}, {
      		"_id": "cb304286-7064-4509-813e-edc36d57623d",
      		"url": "http://initech.zendesk.com/api/v2/tickets/cb304286-7064-4509-813e-edc36d57623d.json",
      		"external_id": "df00b850-ca27-4d9a-a91a-d5b8d130a79f",
      		"created_at": "2016-03-30T11:43:24 -11:00",
      		"type": "task",
      		"subject": "A Nuisance in Saint Lucia",
      		"description": "Nostrud veniam eiusmod reprehenderit adipisicing proident aliquip. Deserunt irure deserunt ea nulla cillum ad.",
      		"priority": "urgent",
      		"status": "pending",
      		"submitter_id": 1,
      		"assignee_id": 11,
      		"organization_id": 106,
      		"tags": ["Missouri", "Alabama", "Virginia", "Virgin Islands"],
      		"has_incidents": false,
      		"due_at": "2016-08-03T04:44:08 -10:00",
      		"via": "chat"
      	}],
      	"assigned_tickets": [{
      		"_id": "1fafaa2a-a1e9-4158-aeb4-f17e64615300",
      		"url": "http://initech.zendesk.com/api/v2/tickets/1fafaa2a-a1e9-4158-aeb4-f17e64615300.json",
      		"external_id": "f6f639a4-a8af-4910-804f-5c3a80252653",
      		"created_at": "2016-01-15T11:52:49 -11:00",
      		"type": "problem",
      		"subject": "A Problem in Russian Federation",
      		"description": "Elit exercitation veniam commodo nulla laboris. Dolore occaecat cillum nisi amet in.",
      		"priority": "low",
      		"status": "solved",
      		"submitter_id": 44,
      		"assignee_id": 1,
      		"organization_id": 115,
      		"tags": ["Georgia", "Tennessee", "Mississippi", "Marshall Islands"],
      		"has_incidents": true,
      		"due_at": "2016-08-07T04:10:34 -10:00",
      		"via": "voice"
      	}, {
      		"_id": "13aafde0-81db-47fd-b1a2-94b0015803df",
      		"url": "http://initech.zendesk.com/api/v2/tickets/13aafde0-81db-47fd-b1a2-94b0015803df.json",
      		"external_id": "6161e938-50cc-4545-acff-a4f23649b7c3",
      		"created_at": "2016-03-30T08:35:27 -11:00",
      		"type": "task",
      		"subject": "A Problem in Malawi",
      		"description": "Lorem ipsum eiusmod pariatur enim. Qui aliquip voluptate cupidatat eiusmod aute velit non aute ullamco.",
      		"priority": "urgent",
      		"status": "solved",
      		"submitter_id": 42,
      		"assignee_id": 1,
      		"organization_id": 122,
      		"tags": ["New Mexico", "Nebraska", "Connecticut", "Arkansas"],
      		"has_incidents": false,
      		"due_at": "2016-08-08T03:25:53 -10:00",
      		"via": "voice"
      	}]
      }]
    JSON
  end

  let(:dataset) do
    Dataset.new do
      collection :users, JsonFileReader.read('./spec/support/data/users.json')
      collection :tickets, JsonFileReader.read('./spec/support/data/tickets.json')
      collection :organizations, JsonFileReader.read('./spec/support/data/organizations.json')

      associate :organizations, with: :users,   via: :organization_id, parent_as: :organization
      associate :organizations, with: :tickets, via: :organization_id, parent_as: :organization

      associate :users, with: :tickets, as: :submitted_tickets, via: :submitter_id, parent_as: :submitter
      associate :users, with: :tickets, as: :assigned_tickets,  via: :assignee_id,  parent_as: :assignee
    end
  end

  let(:query) { QueryParser.parse('select users where name = "Francisca Rasmussen"') }

  describe 'Search' do
    subject(:result) { dataset.search(query) }

    it 'outputs JSON in expected form' do
      expect(result).to eq JSON.parse(expected_result_json, symbolize_names: true)
    end
  end
end
