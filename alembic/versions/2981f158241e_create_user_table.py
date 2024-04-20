"""create user table

Revision ID: 2981f158241e
Revises: 
Create Date: 2024-04-19 15:19:38.405164

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '2981f158241e'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade():
    op.create_table('persona',
                    sa.Column('persona_id', sa.Integer(), nullable=False, index=True),
                    sa.Column('nombres', sa.String(), nullable=False),
                    sa.Column('apellidos', sa.String(), nullable=False),
                    sa.Column('username', sa.String(), nullable=False),
                    sa.Column('password', sa.String(), nullable=True),
                    sa.Column('edad', sa.Integer(), nullable=True),
                    sa.Column('fecha_nacimiento', sa.Date(), nullable=True),
                    sa.Column('genero', sa.String(length=1), nullable=True),
                    sa.PrimaryKeyConstraint('persona_id'),
                    sa.UniqueConstraint('username')
    )
    pass


def downgrade():
    op.drop_table('persona')
    pass
