module.exports = {
    client: 'mysql2',
    connection: {
        host: '127.0.0.1',
        user: 'amit',
        password: '405501N@',
        database: 'new',
    },
    migrations: {
        tableName: 'knex_migrations',
        directory: './migrations',
    },
};
