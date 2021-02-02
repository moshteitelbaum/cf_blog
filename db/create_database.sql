/*
	create_database.sql
	Create all database objects
*/

CREATE TABLE dbo.blog ( 
	id                   uniqueidentifier NOT NULL   ,
	name                 nvarchar(100) NOT NULL   ,
	description          nvarchar(1000)    ,
	created              datetime2(0) NOT NULL   ,
	deleted              datetime2(0)    ,
	CONSTRAINT blog_pk PRIMARY KEY  ( id )
 ) ;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Defines blogs.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog';;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The unique identifier of the blog.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog', @level2type=N'COLUMN',@level2name=N'id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The name of the blog.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog', @level2type=N'COLUMN',@level2name=N'name';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The description of the blog.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog', @level2type=N'COLUMN',@level2name=N'description';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The date and time at which the blog was created.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog', @level2type=N'COLUMN',@level2name=N'created';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The date and time at which the blog was deleted.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog', @level2type=N'COLUMN',@level2name=N'deleted';

CREATE TABLE dbo.blog_post ( 
	id                   uniqueidentifier NOT NULL   ,
	blog_id              uniqueidentifier NOT NULL   ,
	title                nvarchar(250) NOT NULL   ,
	summary              nvarchar(1000)    ,
	body                 ntext NOT NULL   ,
	url                  varchar(1024) NOT NULL   ,
	created              datetime2(0) NOT NULL   ,
	last_modified        datetime2(0) NOT NULL   ,
	published            datetime2(0) NOT NULL   ,
	deleted              datetime2(0)    ,
	CONSTRAINT blog_post_pk PRIMARY KEY  ( id )
 ) ;

CREATE  INDEX blog_post_blog_id_idx ON dbo.blog_post ( blog_id ) ;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Defines blog posts.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post';;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The unique identifier of the blog post.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The blog with which the post is associated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'blog_id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The title of the blog post.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'title';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'A brief summary of the blog post.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'summary';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The body of the blog post.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'body';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The URL of the blog post.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'url';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The date and time the post was created.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'created';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The date and time at which the post was last modified. Defaults to created.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'last_modified';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The date and time at which the blog post was/will be published. Defaults to created.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'published';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The date and time at which the blog post was deleted.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post', @level2type=N'COLUMN',@level2name=N'deleted';

CREATE TABLE dbo.blog_tag ( 
	id                   uniqueidentifier NOT NULL   ,
	blog_id              uniqueidentifier NOT NULL   ,
	tag                  nvarchar(100) NOT NULL   ,
	CONSTRAINT blog_tag_pk PRIMARY KEY  ( id ),
	CONSTRAINT blog_tag_tag_idx UNIQUE ( tag ) 
 ) ;

CREATE  INDEX blog_tag_blog_id_idx ON dbo.blog_tag ( blog_id ) ;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Defines tags associated with a blog.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_tag';;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The unique identifier of the tag.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_tag', @level2type=N'COLUMN',@level2name=N'id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The blog with which the tag is associated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_tag', @level2type=N'COLUMN',@level2name=N'blog_id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The tag.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_tag', @level2type=N'COLUMN',@level2name=N'tag';

CREATE TABLE dbo.blog_user ( 
	id                   uniqueidentifier NOT NULL   ,
	blog_id              uniqueidentifier NOT NULL   ,
	name                 nvarchar(200) NOT NULL   ,
	external_id          nvarchar(100) NOT NULL   ,
	CONSTRAINT blog_user_pk PRIMARY KEY  ( id ),
	CONSTRAINT blog_user_external_id_idx UNIQUE ( external_id ) 
 ) ;

CREATE  INDEX blog_user_blog_id_idx ON dbo.blog_user ( blog_id ) ;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Identifies blog users for authoring posts and comments.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_user';;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The unique identifier of the user.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_user', @level2type=N'COLUMN',@level2name=N'id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The blog with which the user is associated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_user', @level2type=N'COLUMN',@level2name=N'blog_id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The name of the user.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_user', @level2type=N'COLUMN',@level2name=N'name';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'A unique identifier that associates a blog user with a user account from the external user management system.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_user', @level2type=N'COLUMN',@level2name=N'external_id';

CREATE TABLE dbo.blog_post_author ( 
	blog_post_id         uniqueidentifier NOT NULL   ,
	blog_user_id         uniqueidentifier NOT NULL   ,
	rank                 smallint NOT NULL CONSTRAINT defo_blog_post_author_rank DEFAULT 1  ,
	CONSTRAINT blog_post_author_pk PRIMARY KEY  ( blog_user_id, blog_post_id )
 ) ;

CREATE  INDEX blog_post_author_blog_user_id_idx ON dbo.blog_post_author ( blog_user_id ) ;

CREATE  INDEX blog_post_author_blog_post_id_idx ON dbo.blog_post_author ( blog_post_id ) ;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Defines which user account(s) authored which blog post(s).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post_author';;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The blog post authored by the user.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post_author', @level2type=N'COLUMN',@level2name=N'blog_post_id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The author.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post_author', @level2type=N'COLUMN',@level2name=N'blog_user_id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The order in which the author(s) should be ranked.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post_author', @level2type=N'COLUMN',@level2name=N'rank';

CREATE TABLE dbo.blog_post_tag ( 
	blog_post_id         uniqueidentifier NOT NULL   ,
	blog_tag_id          uniqueidentifier NOT NULL   ,
	CONSTRAINT blog_post_tag_pk PRIMARY KEY  ( blog_post_id, blog_tag_id )
 ) ;

CREATE  INDEX blog_post_tag_blog_post_id_idx ON dbo.blog_post_tag ( blog_post_id ) ;

CREATE  INDEX blog_post_tag_blog_tag_id_idx ON dbo.blog_post_tag ( blog_tag_id ) ;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'Defines tags associated with blog posts.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post_tag';;

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The blog post with which the tag is associated.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post_tag', @level2type=N'COLUMN',@level2name=N'blog_post_id';

exec sp_addextendedproperty  @name=N'MS_Description', @value=N'The tag associated with the blog post.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'blog_post_tag', @level2type=N'COLUMN',@level2name=N'blog_tag_id';

ALTER TABLE dbo.blog_post ADD CONSTRAINT blog_post_blog_id_fk FOREIGN KEY ( blog_id ) REFERENCES dbo.blog( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE dbo.blog_tag ADD CONSTRAINT blog_tag_blog_id_fk FOREIGN KEY ( blog_id ) REFERENCES dbo.blog( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE dbo.blog_user ADD CONSTRAINT blog_user_blog_id_fk FOREIGN KEY ( blog_id ) REFERENCES dbo.blog( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE dbo.blog_post_author ADD CONSTRAINT blog_post_author_blog_post_id_fk FOREIGN KEY ( blog_post_id ) REFERENCES dbo.blog_post( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE dbo.blog_post_author ADD CONSTRAINT blog_post_author_blog_user_id_fk FOREIGN KEY ( blog_user_id ) REFERENCES dbo.blog_user( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE dbo.blog_post_tag ADD CONSTRAINT blog_post_tag_blog_post_id_fk FOREIGN KEY ( blog_post_id ) REFERENCES dbo.blog_post( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE dbo.blog_post_tag ADD CONSTRAINT blog_post_tag_blog_tag_id_fk FOREIGN KEY ( blog_tag_id ) REFERENCES dbo.blog_tag( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;
