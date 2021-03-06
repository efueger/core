require 'fast_spec_helper'
require_model 'exporter', sub_dir: 'sales_csv'
require_model 'delivery_exporter', sub_dir: 'sales_csv'
required_constants %w(DeliverySort DeliveryGenerator)

describe SalesCsv::DeliveryExporter do
  let(:expected_array)    { [1, 2, 3] }
  let(:expected_hash)     { { items: expected_array } }
  let(:deliveries)        { double('deliveries') }
  let(:list)              { double('list', ordered_deliveries: deliveries) }
  let(:distributor)       { double('distributor', delivery_list_by_date: list) }
  let(:ids)               { double('ids', is_a?: Integer) }
  let(:date)              { double('date', to_s: '2013-04-04') }
  let(:screen)            { double('screen', to_s: 'delivery') }
  let(:csv_generator)     { double('csv_generator', generate: expected_array) }
  let(:generator)         { double('generator', new: csv_generator) }
  let(:sorter)            { double('sorter', grouped_by_boxes: expected_hash, by_dso: expected_array) }
  let(:valid_args)        { { distributor: distributor, ids: ids, date: date, screen: screen, sorter: sorter, generator: generator } }
  let(:delivery_exporter) { SalesCsv::DeliveryExporter.new(valid_args) }

  describe '#csv' do
    before do
      @data, @file_args = delivery_exporter.csv
    end

    it 'returns the data for a csv export' do
      expect(@data).to eq expected_array
    end

    it 'returns the arguments for a csv export' do
      type     = 'text/csv; charset=utf-8; header=present'
      filename = 'bucky-box-delivery-export-2013-04-04.csv'
      expect(@file_args).to eq({ type: type, filename: filename })
    end
  end
end
