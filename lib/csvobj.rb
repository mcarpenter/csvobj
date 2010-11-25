
require 'csv'

# Generic exception for CSVobj class: actual exceptions are subclassed.
class CSVobjException < Exception ; end

# Raised if the read CSV header row contains a duplicate field.
class CSVobjDuplicateHeader < CSVobjException ; end

# This class represents each row of a CSV file as an object in an array.
# Object attributes are automatically created from the header (first)
# row in the CSV. Note that this class dynamically redefines its own
# attributes and constructor so you should subclass it for any remotely
# serious work.
class CSVobj

  # Parse the given CSV, which may be a multi-line string or
  # IO object (see #parse_s) or an array of row arrays (see
  # #parse_a) and return an array of CSVobjs.
  # Expects the first row to be the headers (these are used
  # for the objects' attributes).
  def self.parse(csv)
    csv.is_a?(Array) ? parse_a(csv) : parse_s(csv)
  end

  # Interpret the given multi-line string or IO object of
  # CSV records and return an array of CSVobjs.
  # Expects the first row to be the headers (these are used
  # for the objects' attributes).
  def self.parse_s(csv)
    rows = s_to_a(csv)
    parse_a(rows)
  end

  # Interpret an array (rows) of arrays (cells) and return
  # an array of CSVobjs.
  # Expects the first row to be the headers (these are used 
  # for the objects' attributes).
  def self.parse_a(rows)
    return [] if rows.empty?

    # Get attributes from first row.
    headers = rows.shift
    attr_symbols = headers.map{ |header| header_to_attr(header) }
    dupes = attr_symbols.uniq!
    raise CSVobjDuplicateHeader, "Duplicate derived headers\n#{dupes}" if dupes

    # Declare attributes and constructor. This will take the form:
    #     #new(header1, header2, ...).
    instance_variables = attr_symbols.map{ |attr| "@#{attr}" }
    class_eval do
      attr_accessor(*attr_symbols)
      define_method :initialize do |*args|
        instance_variables.zip(args).each do |instance_variable, arg|
          instance_variable_set(instance_variable, arg)
        end
      end
    end

    # Define class method #headers to return an array of the (unmangled)
    # CSV headers by defining the method on the metaclass.
    (class << self ; self end).send(:define_method, :headers) { headers }

    # Create and return array of CSVobj, one element for each CSV row
    # (minus the headers).
    rows.map { |row| new(*row) }
  end

  # Convert a header (string) value to a an attribute symbol:
  # Remove leading and trailing whitespace;
  # replace (repeated) non-word characters with a single underscore;
  # prefix leading digit with underscore;
  # remove repeated adjacent underscores;
  # convert to a lower-case symbol.
  def self.header_to_attr(header)
    header.strip. # remove trailing and leading whitespace
      gsub(/\W+/, '_').  # substitute underscore for non-word/digit characters
      sub(/^(\d)/, '_\1'). # if starts with a digit insert a leading underscore
      gsub(/_+/, '_'). # remove duplicate adjacent underscores
      downcase. # convert to lower case
      to_sym # convert to symbol
  end

  # Return an array of (string) values for this CSV object in the order
  # that they were given. See dynamically defined method +headers+ to get
  # the equivalent array of headers.
  def to_a
    self.class.headers.map do |header|
      attr = self.class.header_to_attr(header)
      send(attr)
    end
  end

  # Return a CSV string representing this object. Does not include headers
  # (see #to_s_with_headers).
  def to_s
    a_to_s(to_a)
  end

  # Return a CSV string representing this object including an initial line
  # of headers as originally given on object creation.
  def to_s_with_headers
    a_to_s(self.class.headers) + to_s
  end

  private

  # Abstraction to deal with ruby 1.8/1.9 CSV incompatibilities.
  # Takes an IO-like object or a string, returns an array of CSV objects.
  def self.s_to_a(io_or_string)
    if CSV.const_defined?(:Reader) # ruby 1.8
      CSV::Reader.create( io_or_string ).to_a
    else # ruby 1.9 and beyond
      CSV.parse( io_or_string )
    end
  end

  # Abstraction to deal with ruby 1.8/1.9 CSV class incompatibilities.
  # Takes an array of values and returns a CSV-encoded string.
  def a_to_s(a)
    if CSV.const_defined?(:Reader) # ruby 1.8
      (CSV::Writer.generate(s='') << a).close
      s
    else # ruby 1.9 and beyond
      CSV.generate { |csv| csv << a }
    end
  end

end

