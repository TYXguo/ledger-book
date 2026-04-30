import { prisma } from '../src/common/prisma/client';

const SYSTEM_CATEGORIES = [
  { name: 'Food', type: 'expense', children: ['Groceries', 'Dining Out', 'Drinks'] },
  { name: 'Transport', type: 'expense', children: ['Bus / Metro', 'Taxi', 'Fuel', 'Parking'] },
  { name: 'Housing', type: 'expense', children: ['Rent', 'Mortgage', 'Property Fee', 'Utilities'] },
  { name: 'Shopping', type: 'expense', children: ['Clothing', 'Electronics', 'Home Supplies'] },
  { name: 'Medical', type: 'expense', children: ['Outpatient', 'Pharmacy', 'Insurance'] },
  { name: 'Education', type: 'expense', children: ['Tuition', 'Books', 'Courses'] },
  { name: 'Entertainment', type: 'expense', children: ['Movies', 'Games', 'Travel'] },
  { name: 'Children', type: 'expense', children: ['Diapers', 'Toys', 'Childcare'] },
  { name: 'Social', type: 'expense', children: ['Gifts', 'Red Packet', 'Charity'] },
  { name: 'Other Expense', type: 'expense', children: ['Misc'] },
  { name: 'Salary', type: 'income', children: ['Base Salary', 'Bonus'] },
  { name: 'Side Income', type: 'income', children: ['Freelance', 'Part-time'] },
  { name: 'Investment', type: 'income', children: ['Interest', 'Dividend', 'Capital Gain'] },
  { name: 'Gift Income', type: 'income', children: ['Red Packet', 'Allowance'] },
  { name: 'Other Income', type: 'income', children: ['Refund', 'Misc'] },
];

async function main() {
  console.log('Seeding system categories...');

  let sortOrder = 0;

  for (const cat of SYSTEM_CATEGORIES) {
    const parent = await prisma.category.create({
      data: {
        name: cat.name,
        type: cat.type,
        isSystem: true,
        sortOrder: sortOrder++,
      },
    });

    let childSort = 0;
    for (const childName of cat.children) {
      await prisma.category.create({
        data: {
          name: childName,
          type: cat.type,
          parentId: parent.id,
          isSystem: true,
          sortOrder: childSort++,
        },
      });
    }
  }

  console.log('Done.');
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
