require 'helper'

describe Updown::Check, :vcr do
  describe '.all' do
    it 'returns an array containing the checks' do
      checks = Updown::Check.all
      expect(checks.count).to eq(3)
      expect(checks.map(&:token)).to eq(['e4j4', 'na7t', 'qwew'])
    end
  end

  describe '.get' do
    it 'returns a specific check' do
      check = Updown::Check.get('e4j4')
      expect(check.token).to eq('e4j4')
      expect(check.url).to eq('http://github.com')
    end

    context 'with metrics: true' do
      it 'returns a specific check with its metrics' do
        check = Updown::Check.get('e4j4', metrics: true)
        expect(check.metrics['apdex']).to eq(0.937)
      end
    end
  end

  describe '#downtimes' do
    it "returns an array containing the check's downtimes" do
      check = Updown::Check.get('e4j4')
      downtimes = check.downtimes
      expect(downtimes.count).to eq(2)
      last_downtime = downtimes.first
      expect(last_downtime.error).to eq('no_match')
      expect(last_downtime.started_at).to eq(Time.new(2017, 12, 10, 14, 35, 58, '+00:00'))
      expect(last_downtime.ended_at).to eq(Time.new(2017, 12, 10, 14, 37, 44, '+00:00'))
      expect(last_downtime.duration).to eq(106)
    end
  end

  describe '#get_metrics' do
    it 'get last month metrics by default' do
      check = Updown::Check.get('e4j4')
      metrics = check.get_metrics
      expect(metrics).to include(
        'apdex' => 0.852,
        'timings' => anything,
        'requests' => anything
      )
    end

    context 'with :from and :to' do
      it 'get metrics for a specific timespan' do
        check = Updown::Check.get('e4j4')
        from = Time.new(2017, 12, 10, 12, '+00:00')
        to = Time.new(2017, 12, 10, 14, '+00:00')
        metrics = check.get_metrics from: from, to: to
        expect(metrics).to include(
          'apdex' => 0.917,
          'timings' => anything,
          'requests' => anything
        )
      end
    end

    context 'with :group' do
      it 'groups metrics per location' do
        check = Updown::Check.get('e4j4')
        metrics = check.get_metrics group: :host
        expect(metrics).to include(
          'gra' => {
            'apdex' => 0.898,
            'timings' => anything,
            'requests' => anything,
            'host' => hash_including('city'=>'Gravelines', 'country'=>'France')
          },
          'lan' => {
            'apdex' => 0.948,
            'timings' => anything,
            'requests' => anything,
            'host' => hash_including('city'=>'Los Angeles', 'country'=>'US')
          }
        )
      end
    end
  end

  describe '.create' do
    it 'creates a new check' do
      check = Updown::Check.create('https://news.ycombinator.com/')
      expect(check.token).to eq('kx8w')
      expect(check.url).to eq('https://news.ycombinator.com/')
      expect(check.next_check_at).to eq(Time.new(2017, 12, 10, 15, 31, 31, '+00:00'))
    end

    it 'uses API allowed parameters' do
      check = Updown::Check.create('https://news.ycombinator.com/', period: 30, published: true)
      expect(check.url).to eq('https://news.ycombinator.com/')
      expect(check.period).to eq(30)
      expect(check.published).to eq(true)
    end

    it 'raises an error in case of invalid parameters' do
      expect {
        Updown::Check.create('https://news.ycombinator.com/', period: 45)
      }.to raise_error(Updown::Error, 'URL is already registered (given: "news.ycombinator.com/"), Period is not included in the list (given: 45)')
    end
  end

  describe '#update' do
    it 'updates a check' do
      check = Updown::Check.get('e4j4')
      updated_check = check.update(period: 30)
      expect(updated_check.token).to eq('e4j4')
      expect(updated_check.period).to eq(30)
    end
  end

  describe '#destroy' do
    it 'destroys a check' do
      check = Updown::Check.get('jx3y')
      destroy_check = check.destroy
      expect(destroy_check).to eq(true)
      all_checks = Updown::Check.all
      expect(all_checks.map(&:token)).not_to include('jx3y')
    end
  end
end
