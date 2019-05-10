use Plack::App::GraphQL;

my $schema = q|
  type Todo {
    task: String!
  }

  type Query {
    todos: [Todo]
  }

  type Mutation {
    add_todo(task: String!): Todo
  }
|;

my @data = (
  {task => 'Exercise!'},
  {task => 'Bulk Milk'},
  {task => 'Walk Dogs'},
);

my %root_value = (
  todos => sub {
    return \@data;
  },
  add_todo => sub {
    my ($args, $context, $info) = @_;
    return push @data, $args;
  }
);

return my $app = Plack::App::GraphQL
  ->new(
      schema => $schema, 
      root_value => \%root_value, 
      ui=>1,
      path=>'/graphql')
  ->to_app;